module Galago
  class Router

    NotFound = [ 404, { 'Content-Type' => 'text/plain' }, ["Not Found"]]

    REQUEST_METHODS = [
      "GET",
      "PATCH",
      "POST",
      "PUT",
      "DELETE"
    ]

    attr_reader :routes

    def initialize
      @routes = REQUEST_METHODS.each_with_object({}) do |request_method, routes|
        routes[request_method] = []
        routes
      end
    end

    def add_route(request_method, path, application)
      route = Route.new(request_method, path, application)
      routes[route.request_method] << route
    end

    def has_route?(http_verb, path)
      routes = routes_for_http_verb(http_verb)
      routes.any? { |route| route.path == path }
    end

    def process_request(env)
      routes = routes_for_http_verb(env['REQUEST_METHOD'])
      route  = routes.detect { |route| route.path == env['PATH_INFO'] }

      if route
        Rack::Response.new(route.call(env))
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
