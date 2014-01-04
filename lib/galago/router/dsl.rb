module Galago
  class Router::DSL
    def initialize(router, block)
      @router = router
      instance_eval(&block)
    end

    def get(path, &application)
      @router.add_route("GET", path, application)
    end

    def patch(path, &application)
      @router.add_route("PATCH", path, application)
    end

    def post(path, &application)
      @router.add_route("POST", path, application)
    end

    def put(path, &application)
      @router.add_route("PUT", path, application)
    end

    def delete(path, &application)
      @router.add_route("DELETE", path, application)
    end
  end
end
