require 'galago/router/dsl'
require 'galago/router/errors'
require 'galago/router/path'
require 'galago/router/route'
require 'galago/router/version'

module Galago
  class Router

    GET    = 'GET'.freeze
    PATCH  = 'PATCH'.freeze
    POST   = 'POST'.freeze
    PUT    = 'PUT'.freeze
    DELETE = 'DELETE'.freeze

    REQUEST_METHODS = [GET, PATCH, POST, PUT, DELETE].freeze

    PATH_INFO = 'PATH_INFO'.freeze
    NOT_FOUND = 'Not Found'.freeze

    attr_reader :routes

    def initialize(&block)
      @routes = []
      Router::DSL.new(self, block) if block_given?
    end

    def add_route(request_method, path, application)
      if route = find_route_by_raw_path(path)
        route.add_endpoint(request_method, application)
      else
        route = Route.new(path)
        route.add_endpoint(request_method, application)
        @routes << route
      end
    end

    def has_route?(request_method, path)
      route = find_route(path)
      route && route.allowed_methods.include?(request_method)
    end

    def call(env)
      if route = find_route(env[PATH_INFO])
        route.call(env)
      else
        Rack::Response.new(NOT_FOUND, 404).finish
      end
    end

    private

    def find_route(path)
      routes.find { |route| route.recognizes_path?(path) }
    end

    def find_route_by_raw_path(raw_path)
      routes.find { |route| route.path.to_s == raw_path }
    end

  end
end
