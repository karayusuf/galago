require 'galago/router'
require 'galago/router/response'
require 'galago/router/path'

module Galago
  class Router::Route

    attr_reader :request_method, :path, :action

    def initialize(request_method, path, action)
      @request_method = request_method.to_s.upcase
      @path = Router::Path.new(path)
      @action = action

      validate_action!
      validate_request_method!
    end

    def recognizes_path?(request_path)
      @path.recognizes?(request_path)
    end

    def call(env)
      begin
        Router::Response.for(env, path, action)
      rescue StandardError => e
        Rack::Response.new(e.message, 500)
      end
    end

    private

    def validate_action!
      action.respond_to?(:call) or raise Router::ActionInvalid.new(action)
    end

    def validate_request_method!
      unless Router::REQUEST_METHODS.include?(request_method)
        raise Router::RequestMethodInvalid.new(request_method)
      end
    end
  end
end
