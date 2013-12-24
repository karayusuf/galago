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
      find_endpoint(request_method, path)
    end

    def process_request(env)
      if endpoint = find_endpoint(env['REQUEST_METHOD'], env['PATH_INFO'])
        endpoint.call(env)
      else
        Rack::Response.new("Not Found", 404)
      end
    end

    private

    def find_endpoint(request_method, path)
      endpoints = endpoints_for_request_method(request_method)
      endpoint = endpoints.detect { |endpoint| endpoint.recognizes_path?(path) }
    end

    def endpoints_for_request_method(request_method)
      endpoints.fetch(request_method.to_s.upcase) do
        raise RequestMethodInvalid.new(request_method)
      end
    end

  end
end
