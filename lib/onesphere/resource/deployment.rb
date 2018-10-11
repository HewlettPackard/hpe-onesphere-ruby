require_relative '../resource'
require_relative '../resource_helper'
module OneSphere
  class Deployment < Resource
    include OneSphere::ResourceHelper::PatchOperation
    BASE_URI = '/rest/deployments'.freeze

    def initialize(client, params = {})
      super
    end

    # Updates the deployment attributes
    # @param [Hash] attributes Hash with deployment attributes
    # @option options [String] :name
    def update_deployments(attributes = {})
      patch('add', '/name', attributes)
    end

    # Get deployment console url
    def get_deployment_console_url
      response = @client.rest_post(@data['uri'] + '/console')
      @client.response_handler(response)
    end

    # Perform action. Takes into consideration the current state and does the right thing
    def perform_action(type)
      refresh
      return true if @data['type'] == type
      @logger.debug "Perform action = #{type} on deployment '#{@data['name']}'. Current state: '#{@data['type']}'"
      options = { 'body' => { force: true, type: type } }
      response = @client.rest_post("#{@data['uri']}/actions", options)
      body = @client.response_handler(response)
      # set_all(body)
      true
    end
  end
end
