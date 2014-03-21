module Galago
  class Router
    class Path

      REPEATED_SLASH = /\/{1,}/
      TRAILING_SLASH = /\/$/

      def self.join(*paths)
        path = "/#{paths.join('/')}"
        path = path.gsub(REPEATED_SLASH, '/')
        path = path.gsub(TRAILING_SLASH, '')
        path
      end

      def initialize(path)
        @path = path.to_s
      end

      def recognizes?(request_path)
        request_path =~ regex
      end

      def named_parameters
        @path_parameters ||= @path.scan(/\:(\w+)/).flatten
      end

      def params_from(env)
        request = Rack::Request.new(env)
        params = request.params

        if path_params = identify_params_in_path(request.path)
          params.merge(path_params)
        else
          params
        end
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
        /\A#{regexp}$/
      end

      def identify_params_in_path(path)
        if match = regex.match(path)
          Hash[named_parameters.zip(match.captures)]
        end
      end

    end
  end
end

