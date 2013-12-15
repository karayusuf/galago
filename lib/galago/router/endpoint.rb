require 'galago/router'
require 'galago/router/response'

module Galago
  class Router::Endpoint

    attr_reader :request_method, :path, :action

    def initialize(request_method, path, action)
      @request_method = request_method.to_s.upcase
      @path = path
      @action = action

      validate_action!
      validate_request_method!
    end

    def call(env)
      Router::Response.for(env, action)
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
