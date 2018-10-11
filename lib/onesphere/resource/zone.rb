require_relative '../resource'

module OneSphere
  # Zone resource implementation
  class Zone < Resource
    BASE_URI = '/rest/zones'.freeze

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneSphere::Client] client The client object for OneSphere
    # @param [Hash] params The options for this resource (key-value pairs)
    def initialize(client, params = {})
      super
    end

    # Get appliance-image url
    def get_appliance_image_url
      response = @client.rest_get(@data['uri'] + '/appliance-image')
      @client.response_handler(response)
    end

    # Get zone task status
    def get_zone_task_Status
      response = @client.rest_get(@data['uri'] + '/task-status')
      @client.response_handler(response)
    end

    # Get zone connections
    def get_zone_connections
      response = @client.rest_get(@data['uri'] + '/connections')
      @client.response_handler(response)
    end
  end
end
