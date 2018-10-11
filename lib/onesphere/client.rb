module OneSphere

  # Client provides an interface to make calls to the OneSphere API
  class Client

    attr_reader :host_url, :token

    def initialize(host_url, token)
      @host_url = host_url
      @token = token
    end

    def disconnect()
      send_http_req(@@DELETE, "/rest/session")
    end

    # Account APIs

    # view="full"
    def get_account(view)
      # params = { view: view }
      # send_http_req(@@GET, "/rest/account", params, nil)
      raise not_implemented_error(@@GET, "/rest/account", "account")
    end


    private

    @@GET = "GET"
    @@POST = "POST"
    @@PUT = "PUT"
    @@PATCH = "PATCH"
    @@DELETE = "DELETE"

    def build_url(path) @host_url + path end

    def send_http_req(method, path, params = nil, body = nil)

      # parse body from hash to json
      payload = body


      { ok: true }

    end

    def not_implemented_error(method, endpoint, path)
      raise NotImplementedError.new("%{method} %{endpoint} is not yet implemented.\nSee: %{host}/docs/api/endpoint?&path=%%2F%{path}" % {
        method: method,
        endpoint: endpoint,
        path: path
      })
    end

  end
end
