module ResourceMQ
  module Service
    class Base
      attr_accessor :request, :response

      def call(request, response, action)
        @request = request
        @response = response

        public_send(action)

        @response
      end

      def respond_with(object)
        @response.object = object
      end
    end
  end
end
