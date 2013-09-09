module ResourceMQ
  module Service
    class Dispatcher
      attr_accessor :request

      delegate :service_name, to: :request

      class << self
        def dispatch(request)
          new(request).dispatch
        end
      end

      def initialize(request)
        @request = request
      end

      def dispatch
        service.call(request_message, response_message, action)
      end

      def service
        @service ||= "#{service_name.camelize}Service".constantize.new
      end

      def action
        @request.method_name
      end

      def request_message
        @request_message ||= request_klass.decode(@request.request_proto)
      end

      def response_message
        @response_message ||= response_klass.new
      end

      private

      def messages_namespace
        "#{service_name.singularize.camelize}Messages"
      end

      def request_klass
        "#{messages_namespace}::#{action.camelize}".constantize
      end

      def response_klass
        klass_name = Router.action_return_type(service_name, action)
        "#{messages_namespace}::#{klass_name}".constantize
      end
    end
  end
end
