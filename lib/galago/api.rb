module Galago
  class API
    def self.router
      @router ||= Router.new
    end

    def self.routes(&block)
      Router::DSL.new(router, block)
    end

    def self.call(env)
      router.process_request(env)
    end
  end
end

