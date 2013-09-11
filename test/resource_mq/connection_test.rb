require 'test_helper'

module ResourceMQ
  class ResponseDummy
    def initialize(options = {})
    end
  end

  class ConnectionTest < MiniTest::Unit::TestCase
    def setup
      @params     = {id: 123}
      @connection = ResourceMQ::Connection.request(:index, params: @params)
      @response   = @connection.response(ResponseDummy)
    end
    def test_new_connection
      assert_equal 'index', @connection.connection_request.action
      assert_equal @params, @connection.connection_request.params
      assert_instance_of ResponseDummy, @response.message
    end
  end
end
