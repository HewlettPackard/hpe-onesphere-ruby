# Contains all the custom Exception classes
module OneSphere
  # Error class allowing storage of a data attribute
  class OneSphereError < ::StandardError
    attr_accessor :data
    MESSAGE = '(No message)'.freeze

    def initialize(msg = self.class::MESSAGE, data = nil)
      @data = data
      super(msg)
    end

    # Shorthand method to raise an error.
    # @example
    #   OneSphere::OneSphereError.raise! 'Message', { data: 'stuff' }
    def self.raise!(msg = self::MESSAGE, data = nil)
      raise new(msg, data)
    end
  end

  class ConnectionError < OneSphereError # Cannot connect to client/resource
    MESSAGE = 'Cannot connect to client/resource'.freeze
  end

  class InvalidURL < OneSphereError # URL is invalid
    MESSAGE = 'URL is invalid'.freeze
  end

  class InvalidClient < OneSphereError # Client configuration is invalid
    MESSAGE = 'Client configuration is invalid'.freeze
  end

  class InvalidResource < OneSphereError # Failed resource validations
    MESSAGE = 'Failed resource validations'.freeze
  end

  class IncompleteResource < OneSphereError # Missing required resource data to complete action
    MESSAGE = 'Missing required resource data to complete action'.freeze
  end

  class MethodUnavailable < OneSphereError # Resource does not support this method
    MESSAGE = 'Resource does not support this method'.freeze
  end

  class InvalidRequest < OneSphereError # Could not make request
    MESSAGE = 'Could not make request'.freeze
  end

  class BadRequest < OneSphereError # 400
    MESSAGE = '400'.freeze
  end

  class Unauthorized < OneSphereError # 401
    MESSAGE = '401'.freeze
  end

  class NotFound < OneSphereError # 404
    MESSAGE = '404'.freeze
  end

  class RequestError < OneSphereError # Other bad response codes
    MESSAGE = 'Bad response code'.freeze
  end
end
