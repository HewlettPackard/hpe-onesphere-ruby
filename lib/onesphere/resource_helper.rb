module OneSphere
  # Contains helper methods to include certain functionalities on resources
  module ResourceHelper
    # Contains helper method to call patch endpoint of resource
    module PatchOperation
      # Performs a specific patch operation for the given resource.
      # If the resource supports the particular operation, the operation is performed
      # and a response is returned to the caller with the results.
      # @param [String] operation The operation to be performed
      # @param [String] path The path of operation
      # @param [String] value The value
      def patch(operation, path, value = nil, header_options = {})
        ensure_client && ensure_uri
        body = { 'op' => operation, 'path' => path, 'value' => value }
        response = @client.rest_patch(@data['uri'], { 'Content-Type' => 'application/json-patch+json', 'body' => [body] })
        @client.response_handler(response)
      end
    end
  end
end
