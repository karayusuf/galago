module Galago
  class Router::Path

    def initialize(path)
      @path = path.to_s
    end

    def recognizes?(request_path)
      request_path =~ regex
    end

    def named_parameters
      @path_parameters ||= @path.scan(/\:(\w+)/).flatten
    end

    def add_path_params_to_env(env)
      request = Rack::Request.new(env)
      identify_params_in_path(request.path).each do |key, value|
        request.update_param(key, value)
      end
    end

    def identify_params_in_path(request_path)
      values = regex.match(request_path).captures
      Hash[named_parameters.zip(values)]
    end

    def to_s
      @path
    end

    private

    def regex
      @regex_path ||= convert_path_to_regex(@path)
    end

    def convert_path_to_regex(path)
      regexp = path.to_s.gsub(/\:\w+/, '([\w-]+)')
      Regexp.new("^#{regexp}$")
    end

  end
end
