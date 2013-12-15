module Galago
  class Router::Response

    def self.for(env, block)
      new(env, block).call.to_s
    end

    def initialize(env, block)
      @block = block
      @request = Rack::Request.new(env)
    end

    def params
      @request.params
    end

    def call
      instance_eval(&@block)
    end

  end
end
