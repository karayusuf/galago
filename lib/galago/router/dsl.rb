module Galago
  class Router::DSL
    def initialize(router, block)
      @router = router
      instance_eval(&block)
    end

    def get(path, application)
      @router.add_endpoint("GET", path, application)
    end

    def patch(path, application)
      @router.add_endpoint("PATCH", path, application)
    end

    def post(path, application)
      @router.add_endpoint("POST", path, application)
    end

    def put(path, application)
      @router.add_endpoint("PUT", path, application)
    end

    def delete(path, application)
      @router.add_endpoint("DELETE", path, application)
    end
  end
end
