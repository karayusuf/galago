module Galago
  class Router::Response

    def self.for(env, block)
      response = new(env, block)
      Rack::Response.new(response.body, response.status)
    end

    attr_reader :status

    def initialize(env, block)
      @block = block
      @request = Rack::Request.new(env)
      @status = 200
    end

    def params
      @request.params
    end

    def body
      begin
        instance_eval(&@block)
      rescue StandardError => error
        @status = 500
        error.message
      end
    end

  end
end
