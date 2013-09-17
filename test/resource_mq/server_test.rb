require 'test_helper'

module ResourceMQ
  class Server
    module Testing
      class ServerTest < ActiveSupport::TestCase
        class DispatcherMock
          def dispatch(request)
            @request = request

            {status: 200, message: {}, errors: {}}
          end

          def request
            @request
          end
        end

        def dispatcher
          @dispatcher ||= DispatcherMock.new
        end

        def test_handle_request
          request = {
              resource:            'products',
              action:              'index',
              params:              {},
              headers:             {},
              resource_attributes: {}
          }.to_json
          server  = Server.new

          server.stub(:dispatcher, dispatcher) do
            @response = server.handle_request(request)
          end

          assert_equal @response, {status: 200, message: {}, errors: {}}
        end
      end
    end
  end
end
