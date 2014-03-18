module Galago
  class Router
    class DSL
      def initialize(router, block)
        @router = router
        @namespace = ''
        instance_eval(&block)
      end

      def namespace(new_namespace)
        @namespace << "/#{new_namespace}"
        yield
        @namespace = ''
      end

      def get(path, options)
        add_route("GET", path, options[:to])
      end

      def patch(path, options)
        add_route("PATCH", path, options[:to])
      end

      def post(path, options)
        add_route("POST", path, options[:to])
      end

      def put(path, options)
        add_route("PUT", path, options[:to])
      end

      def delete(path, options)
        add_route("DELETE", path, options[:to])
      end

      private

      def add_route(method, path, application)
        path_with_namespace = Path.join(@namespace, path)
        @router.add_route(method, path_with_namespace, application)
      end

    end
  end
end
