module Galago
  class Router
    class DSL
      def initialize(router, block)
        @router = router
        instance_eval(&block)
      end

      def get(path, options)
        @router.add_route("GET", path, options[:to])
      end

      def patch(path, options)
        @router.add_route("PATCH", path, options[:to])
      end

      def post(path, options)
        @router.add_route("POST", path, options[:to])
      end

      def put(path, options)
        @router.add_route("PUT", path, options[:to])
      end

      def delete(path, options)
        @router.add_route("DELETE", path, options[:to])
      end
    end
  end
end
