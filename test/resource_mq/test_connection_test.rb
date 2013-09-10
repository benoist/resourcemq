require 'test_helper'

module ResourceMQ
  class ProductsDummyRequest < Struct.new(:resource, :action)
  end

  class TestConnectionTest < Minitest::Unit::TestCase
    def test_stub
      response = { message: 123 }
      ResourceMQ::TestConnection.stub(:products, :index, response)
      assert_equal ResourceMQ::TestConnection.stubbed_resources[:products][:index], response
    end

    def test_call
      products_index_request = ProductsDummyRequest.new(:products, :index)
      ResourceMQ::TestConnection.stub(:products, :index, "a response")
      assert_equal ResourceMQ::TestConnection.send_request(products_index_request), "a response"
    end
  end
end

