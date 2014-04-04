module Galago
  class Router
    class Route

      attr_reader :path

      def initialize(path)
        @path = Router::Path.new(path)
        @endpoints = { 'OPTIONS' => options }
      end

      def add_endpoint(request_method, endpoint)
        @endpoints[request_method] = endpoint
      end

      def allowed_methods
        @endpoints.keys.sort
      end

      def recognizes_path?(request_path)
        @path.recognizes?(request_path)
      end

      def call(env)
        env['galago_router.path'] = @path.to_s
        env['galago_router.params'] = @path.params_from(env)

        endpoint = @endpoints.fetch(env['REQUEST_METHOD'], method_not_allowed)
        endpoint.call(env)
      end

      private

      def method_not_allowed
        ->(env) { [405, { 'Allow' => allowed_methods.join(', ') }, []] }
      end

      def options
        ->(env) { [200, { 'Allow' => allowed_methods.join(', ') }, []] }
      end

    end
  end
end

