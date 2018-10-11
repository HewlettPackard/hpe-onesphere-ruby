# Client
# - has interface for making api calls

# need a lib for building http api requests
# API::call(:type, "path", { params }, { payload })

require "logger"
require "addressable"
require "json"
require "net/http"
require "onesphere/version"
require "onesphere/client"

module OneSphere
  # Connect returns a new OneSphere::Client on successful authentication

  REQUIRED_CREDENTIAL_PARAMS = [:host_url, :username, :password]

  def self.Connect(credentials)

    REQUIRED_CREDENTIAL_PARAMS.each { |param|
      raise ArgumentError.new "Required auth parameter: #{param} is not set" if credentials[param].nil?
    }

    token = Authenticate(credentials)

    Client.new(credentials[:host_url], token)

  rescue ArgumentError => err

    puts "onesphere.Connect failed."
    puts "onesphere.Connect credentials: #{credentials}"
    puts "onesphere.Connect error: #{err}"

    raise err
  end

  private

  def self.Authenticate(credentials)
    full_url = credentials[:host_url]+"/rest/session"

    payload = {
      username: credentials[:username],
      password: credentials[:password]
    }

    # req.Header.Set("Accept", "application/json")
    # req.Header.Set("Content-Type", "application/json")
    #
    # POST to fullUrl with json

    # parse response, should be json with token

    # return token
    type = :post
    @url = credentials[:host_url]
    path = "/rest/session"
    @logger = Logger.new(STDOUT)

    @logger.debug "Making :#{type} rest call to #{@url}#{path}"
    raise InvalidRequest, 'Must specify path' unless path
    uri = URI.parse(Addressable::URI.escape(@url + path))
    http = build_http_object(uri)
    request = build_request(type, uri, {
      :body => payload
    })
    response = http.request(request)
    @logger.debug "  Response: Code=#{response.code}. Headers=#{response.to_hash}\n  Body=#{response.body}"
    # if response.class <= Net::HTTPRedirection && redirect_limit > 0 && response['location']
    #   @logger.debug "Redirecting to #{response['location']}"
    #   return rest_api(type, response['location'], options, redirect_limit - 1)
    # end
    response
  end

    # Builds a http object using the data given
  def self.build_http_object(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http.read_timeout = @timeout if @timeout # Timeout for a request
      http.open_timeout = @timeout if @timeout # Timeout for a connection
      http
    end

    # Builds a request object using the data given
  def self.build_request(type, uri, options = {})
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
        @logger.debug "  Options #{key}: #{val}"
        if key.to_s.downcase == 'body'
          @logger.debug "  GOOD #{val.to_json}"
          request.body = val.to_json rescue val
        else
          request[key] = val
        end
      end

      @logger.debug "  Body: #{request.body}" # Warning: This may include passwords and tokens
      @logger.debug "  Options: #{options}" # Warning: This may include passwords and tokens

      request
    end
end

