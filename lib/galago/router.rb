module Galago
  class Router

    REQUEST_METHODS = [
      "GET",
      "PATCH",
      "POST",
      "PUT",
      "DELETE"
    ]

    attr_reader :endpoints

    def initialize
      @endpoints = REQUEST_METHODS.each_with_object({}) do |request_method, endpoints|
        endpoints[request_method] = []
        endpoints
      end
    end

    def add_endpoint(request_method, path, application)
      endpoint = Endpoint.new(request_method, path, application)
      endpoints[endpoint.request_method] << endpoint
    end

    def has_endpoint?(request_method, path)
      endpoints = endpoints_for_request_method(request_method)
      endpoints.any? { |endpoint| endpoint.recognizes_path?(path) }
    end

    def process_request(env)
      endpoints = endpoints_for_request_method(env['REQUEST_METHOD'])
      endpoint = endpoints.detect do |endpoint|
        endpoint.recognizes_path?(env['PATH_INFO'])
      end

      if endpoint
        endpoint.call(env)
      else
        Rack::Response.new("Not Found", 404)
      end
    end

    private

    def endpoints_for_request_method(request_method)
      endpoints.fetch(request_method.to_s.upcase) do
        raise RequestMethodInvalid.new(request_method)
      end
    end

  end
end
