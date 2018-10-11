require 'addressable'
require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'net/http/post/multipart'

module OneSphere
  # Contains all of the methods for making API REST calls
  module Rest
    READ_TIMEOUT = 300 # in seconds, 5 minutes

    # Makes a restful API request to OneSphere
    # @param [Symbol] type The rest method/type Options: [:get, :post, :delete, :patch, :put]
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @param [Integer] redirect_limit Number of redirects it is allowed to follow
    # @return [NetHTTPResponse] Response object
    def rest_api(type, path, options = {}, redirect_limit = 3)
      @logger.debug "Making :#{type} rest call to #{@url}#{path}"
      raise InvalidRequest, 'Must specify path' unless path
      uri = URI.parse(Addressable::URI.escape(@url + path))
      http = build_http_object(uri)
      request = build_request(type, uri, options.dup)
      response = http.request(request)
      @logger.debug "  Response: Code=#{response.code}. Headers=#{response.to_hash}\n  Body=#{response.body}"
      if response.class <= Net::HTTPRedirection && redirect_limit > 0 && response['location']
        @logger.debug "Redirecting to #{response['location']}"
        return rest_api(type, response['location'], options, redirect_limit - 1)
      end
      response
    end

    # Makes a restful GET request to OneSphere
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @return [NetHTTPResponse] Response object
    def rest_get(path, options = {})
      rest_api(:get, path, options)
    end

    # Makes a restful POST request to OneSphere
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @return [NetHTTPResponse] Response object
    def rest_post(path, options = {})
      rest_api(:post, path, options)
    end

    # Makes a restful PUT request to OneSphere
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @return [NetHTTPResponse] Response object
    def rest_put(path, options = {})
      rest_api(:put, path, options)
    end

    # Makes a restful PATCH request to OneSphere
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @return [NetHTTPResponse] Response object
    def rest_patch(path, options = {})
      rest_api(:patch, path, options)
    end

    # Makes a restful DELETE request to OneSphere
    # @param [String] path The path for the request. Usually starts with "/rest/"
    # @param [Hash] options The options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @option options [Integer] :auth (client.token) Authentication token to use for this request
    # @return [NetHTTPResponse] Response object
    def rest_delete(path, options = {})
      rest_api(:delete, path, options)
    end

    RESPONSE_CODE_OK           = 200
    RESPONSE_CODE_CREATED      = 201
    RESPONSE_CODE_ACCEPTED     = 202
    RESPONSE_CODE_NO_CONTENT   = 204
    RESPONSE_CODE_BAD_REQUEST  = 400
    RESPONSE_CODE_UNAUTHORIZED = 401
    RESPONSE_CODE_NOT_FOUND    = 404

    # Handles the response from a rest call.
    #   If an asynchronous task was started, this waits for it to complete.
    # @param [HTTPResponse] response HTTP response
    # @param [Boolean] wait_on_task Wait on task (or just return task details)
    # @return [Hash] The parsed JSON body
    def response_handler(response, wait_on_task = false)
      case response.code.to_i
      when RESPONSE_CODE_OK # Synchronous read/query
        begin
          return JSON.parse(response.body)
        rescue JSON::ParserError => e
          @logger.warn "Failed to parse JSON response. #{e}"
          return response.body
        end
      when RESPONSE_CODE_CREATED # Synchronous add
        JSON.parse(response.body)
      when RESPONSE_CODE_ACCEPTED # Asynchronous add, update or delete
        return JSON.parse(response.body) unless wait_on_task
        @logger.debug "Waiting for task: response.header['location']"
        uri = response.header['location'] || JSON.parse(response.body)['uri'] # If task uri is not returned in header
        task = wait_for(uri)
        return true unless task['associatedResource'] && task['associatedResource']['resourceUri']
        resource_data = rest_get(task['associatedResource']['resourceUri'])
        JSON.parse(resource_data.body)
      when RESPONSE_CODE_NO_CONTENT # Synchronous delete
        {}
      when RESPONSE_CODE_BAD_REQUEST
        BadRequest.raise! "400 BAD REQUEST #{response.body}", response
      when RESPONSE_CODE_UNAUTHORIZED
        Unauthorized.raise! "401 UNAUTHORIZED #{response.body}", response
      when RESPONSE_CODE_NOT_FOUND
        NotFound.raise! "404 NOT FOUND #{response.body}", response
      else
        RequestError.raise! "#{response.code} #{response.body}", response
      end
    end


    private

    # Builds a http object using the data given
    def build_http_object(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http.read_timeout = @timeout if @timeout # Timeout for a request
      http.open_timeout = @timeout if @timeout # Timeout for a connection
      http
    end

    # Builds a request object using the data given
    def build_request(type, uri, options)
      case type.downcase.to_sym
      when :get
        request = Net::HTTP::Get.new(uri.request_uri)
      when :post
        request = Net::HTTP::Post.new(uri.request_uri)
      when :put
        request = Net::HTTP::Put.new(uri.request_uri)
      when :patch
        request = Net::HTTP::Patch.new(uri.request_uri)
      when :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      else
        raise InvalidRequest, "Invalid rest method: #{type}. Valid methods are: get, post, put, patch, delete"
      end

      options['Authorization'] ||= @token
      options['Content-Type'] ||= 'application/json'
      options['Accept'] ||= 'application/json'

      options.delete('Content-Type')  if [:none, 'none', nil].include?(options['Content-Type'])
      options.delete('Authorization') if [:none, 'none', nil].include?(options['Authorization'])
      options.delete('Accept')  if [:none, 'none', nil].include?(options['Accept'])

      options.each do |key, val|
        if key.to_s.downcase == 'body'
          request.body = val.to_json rescue val
        else
          request[key] = val
        end
      end

      @logger.debug "  Options: #{options}" # Warning: This may include passwords and tokens

      request
    end
  end
end
