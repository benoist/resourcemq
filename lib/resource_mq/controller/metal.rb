module ResourceMQ
  module Controller
    module Metal
      attr_accessor :request, :response, :action_name

      delegate :params, :headers, to: :request

      def process(action)
        @action_name = action.to_s

        process_action(action)
      end

      def process_action(action)
        self.__send__(action)
      end

      def attributes
        request.resource_attributes
      end
    end
  end
end
