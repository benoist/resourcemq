require 'test_helper'

module Server
  class ServerTest < ActiveSupport::TestCase
    class DispatcherMock
      def dispatch(request)
        @request = request

        response = ResourceMQ::Response.new(status: 200, message: {})
        response.message_klass = Class.new(ResourceMQ::Resource)
        response
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
      server  = ResourceMQ::Server.new

      server.stub(:dispatcher, dispatcher) do
        @response = server.handle_request(request)
      end

      assert_kind_of ResourceMQ::Request, dispatcher.request
      assert_equal @response, {status: 200, message: {}, errors: {}}.to_json
    end
  end
end
