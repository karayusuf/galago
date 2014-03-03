module Galago
  class Router
    class ActionInvalid < ArgumentError
      def initialize(action)
        @action = action
      end

      def message
        "Action does not have a call method: #{@action.inspect}"
      end
    end

    class RequestMethodInvalid < ArgumentError
      def initialize(request_method)
        @request_method = request_method
      end

      def message
        "Got: #{@request_method}\nExpected one of: #{REQUEST_METHODS}"
      end
    end
  end
end

