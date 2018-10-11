require_relative '../resource'

module OneSphere
  # Membership resource implementation
  class Membership < Resource
    BASE_URI = '/rest/memberships'.freeze

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneSphere::Client] client The client object for OneSphere
    # @param [Hash] params The options for this resource (key-value pairs)
    def initialize(client, params = {})
      super
    end

    def create!
        unavailable_method
    end

    # Delete resource from OneSphere
    # @param [Hash] header The header options for the request (key-value pairs)
    # @return [true] if resource was deleted successfully
    def delete(header = self.class::DEFAULT_REQUEST_HEADER)
      ensure_client
      response = @client.rest_delete(BASE_URI, {body: @data})
      @client.response_handler(response)
      true
    end
  end
end
