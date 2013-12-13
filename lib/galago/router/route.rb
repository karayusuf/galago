module Galago
  class Router::Route

    class RequestMethodInvalid < ArgumentError; end
    REQUEST_METHODS = ["GET", "PATCH", "POST", "PUT", "DELETE"]

    def initialize(request_method, path, action)
      @request_method = sanitize_request_method!(request_method)
      @path = path
      @action = action
    end

    def request_method
      @request_method.to_s.upcase
    end

    def path
      @path
    end

    def call(env)
      @action.call(env)
    end

    private

    def sanitize_request_method!(request_method)
      request_method = request_method.to_s.upcase

      if REQUEST_METHODS.include?(request_method)
        request_method
      else
        raise RequestMethodInvalid.new(request_method)
      end
    end
  end
end
