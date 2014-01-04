require "galago/version"

require "galago/router"
require "galago/router/dsl"
require "galago/router/route"
require "galago/router/errors"
require "galago/router/path"

module Galago
  class Application
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
