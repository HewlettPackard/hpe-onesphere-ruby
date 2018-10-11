require_relative '../resource'

module OneSphere
  # Status resource implementation
  class Status < Resource
    BASE_URI = '/rest/status'.freeze

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneSphere::Client] client The client object for OneSphere
    # @param [Hash] params The options for this resource (key-value pairs)
    def initialize(client, params = {})
      super
    end
  end
end
