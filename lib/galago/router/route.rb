module Galago
  class Router
    class Route

      attr_reader :request_method, :path, :action

      def initialize(request_method, path, action)
        @request_method = request_method.to_s.upcase
        @path = Router::Path.new(path)
        @action = action

        validate_action!
        validate_request_method!
      end

      def recognizes_path?(request_path)
        @path.recognizes?(request_path)
      end

      def call(env)
        @path.add_path_params_to_env(env)
        action.call(env)
      end

      private

      def validate_action!
        action.respond_to?(:call) or raise Router::ActionInvalid.new(action)
      end

      def validate_request_method!
        unless Router::REQUEST_METHODS.include?(request_method)
          raise Router::RequestMethodInvalid.new(request_method)
        end
      end
    end
  end
end

