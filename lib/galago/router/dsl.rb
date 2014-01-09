module Galago
  class Router::DSL
    def initialize(router, block)
      @router = router
      instance_eval(&block)
    end

    def get(path, options = {}, &application)
      application = block_given? ? application : options[:to]
      @router.add_route("GET", path, application)
    end

    def patch(path, &application)
      application = block_given? ? application : options[:to]
      @router.add_route("PATCH", path, application)
    end

    def post(path, &application)
      application = block_given? ? application : options[:to]
      @router.add_route("POST", path, application)
    end

    def put(path, &application)
      application = block_given? ? application : options[:to]
      @router.add_route("PUT", path, application)
    end

    def delete(path, &application)
      application = block_given? ? application : options[:to]
      @router.add_route("DELETE", path, application)
    end
  end
end
