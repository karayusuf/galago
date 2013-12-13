module Galago
  class Router

    class HttpVerbInvalid < ArgumentError; end

    NotFound = [ 404, { 'Content-Type' => 'text/plain' }, ["Not Found"]]

    attr_reader :routes

    def initialize
      @routes = {
        "GET"    => {},
        "PATCH"  => {},
        "POST"   => {},
        "PUT"    => {},
        "DELETE" => {}
      }
    end

    def add_route(http_verb, path, application)
      routes = routes_for_http_verb(http_verb)
      routes[path] = application
    end

    def has_route?(http_verb, path)
      routes = routes_for_http_verb(http_verb)
      routes.has_key?(path)
    end

    def process_request(env)
      routes = routes_for_http_verb(env['REQUEST_METHOD'])
      endpoint = routes.fetch(env['PATH_INFO'], nil)

      if endpoint
        Rack::Response.new(endpoint.call(env))
      else
        NotFound
      end
    end

    private

    def routes_for_http_verb(http_verb)
      @routes.fetch(http_verb.to_s.upcase) do
        message = "Got: #{http_verb}.\n"
        message << "Expected one of: GET, PATCH, POST, PUT, DELETE"
        fail HttpVerbInvalid.new(message)
      end
    end

  end
end
