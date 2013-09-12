module ResourceMQ
  module Client
    class Test
      attr_accessor :server

      def initialize(server)
        @server = server
      end

      def send_request(request)
        @server.handle_request(request)
      end
    end
  end
end
