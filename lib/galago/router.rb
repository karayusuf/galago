module Galago
  class Router

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

    def has_route?(request_method, path)
      routes = routes_for_request_method(request_method)
      routes.any? { |route| route.path == path }
    end

    def process_request(env)
      routes = routes_for_request_method(env['REQUEST_METHOD'])
      route  = routes.detect { |route| route.path == env['PATH_INFO'] }

      if route
        begin
          Rack::Response.new(route.call(env))
        rescue StandardError => e
          Rack::Response.new(e.message, 500)
        end
      else
        Rack::Response.new("Not Found", 404)
      end
    end

    private

    def routes_for_request_method(request_method)
      @routes.fetch(request_method.to_s.upcase) do
        raise RequestMethodInvalid.new(request_method)
      end
    end

  end
end
