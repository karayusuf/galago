module Galago
  class Router::Response

    def self.for(env, path, block)
      response = new(env, path, block)
      Rack::Response.new(response.body, response.status)
    end

    attr_reader :status

    def initialize(env, path, block)
      @path = path
      @block = block
      @request = Rack::Request.new(env)
      @status = 200
    end

    def params
      @params ||= begin
        path_parameters = @path.identify_params_in_path(@request.path_info)
        @request.params.merge(path_parameters)
      end
    end

    def body
      begin
        instance_eval(&@block).to_s
      rescue StandardError => error
        @status = 500
        error.message
      end
    end

  end
end
