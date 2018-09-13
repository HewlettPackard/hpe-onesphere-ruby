require "onesphere/version"
require "onesphere/client"

module OneSphere
  # Connect returns a new OneSphere::Client on successful authentication

  REQUIRED_CREDENTIAL_PARAMS = [:host_url, :username, :password]

  def self.Connect(credentials)

    REQUIRED_CREDENTIAL_PARAMS.each { |param|
      credentials.fetch(param) { |missing|
        raise ArgumentError.new "Missing required argument #{missing}"
      }
    }

    token = Authenticate(credentials)

    Client.new(host_url, token)
  end

  private

  def self.Authenticate(credentials)
    fullUrl = credentials[:host_url]+"/rest/session"

    payload = {
      userName: credentials[:user_name],
      password: credentials[:password]
    }

    # req.Header.Set("Accept", "application/json")
    # req.Header.Set("Content-Type", "application/json")
    #
    # POST to fullUrl with json

    # parse response, should be json with token

    # return token

    "make pretend token"
  end

end

