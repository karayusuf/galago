module Galago
  class Router::Path

    def initialize(path)
      @path = path.to_s
    end

    def regex
      @regex_path ||= convert_path_to_regex(@path)
    end

    def recognizes?(request_path)
      request_path =~ regex
    end

    def path_parameters
      @path_parameters ||= @path.scan(/\:\w+/).flatten
    end

    def to_s
      @path
    end

    private

    def convert_path_to_regex(path)
      regexp = path.to_s.gsub(/\:\w+/, '([\w-]+)')
      Regexp.new("^#{regexp}$")
    end

  end
end
