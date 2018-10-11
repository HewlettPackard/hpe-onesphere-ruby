require_relative '../resource'

module OneSphere
  # Project resource implementation
  class Project < Resource
    BASE_URI = '/rest/projects'.freeze

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneSphere::Client] client The client object for OneSphere
    # @param [Hash] params The options for this resource (key-value pairs)
    def initialize(client, params = {})
      super
    end
  end
end
