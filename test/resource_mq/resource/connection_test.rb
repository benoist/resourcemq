module ResourceMQ
  module Resource
    module Connection
      module Testing
        class Product < ResourceMQ::Resource::Base
        end

        class MockConnection
          attr_accessor :requests

          def initialize
            @requests = []
          end

          def send_request(request)
            @requests << request
            @next_response
          end

          def next_response(response)
            @next_response = response
          end
        end

        class ResourceConnection < ResourceMQ::Resource::Base
          attribute :name, String
        end

        class RequestTest < ActiveSupport::TestCase
          def setup
            @connection = MockConnection.new
            @connection.next_response(ResourceMQ::Response.new(status: 200, message: {name: 'name'}, errors: {}))
            ResourceConnection.connection = @connection
          end

          def test_request
            ResourceConnection.request('action', params: {})
            assert_equal @connection.requests.first.action, 'action'
          end

          def test_success_response
            resource = ResourceConnection.request('action', params: {})
            assert_equal resource.name, 'name'
          end
        end

        class ConnectionTest < ActiveSupport::TestCase

          def test_connection
            ResourceMQ::Resource::Base.connection = 'new_connection'
            assert_equal Product.connection, 'new_connection'
          end
        end
      end
    end
  end
end
