require 'test_helper'

module Response
  class Products
    include ResourceMQ::Message

    attribute :name, String
  end

  class ResponseTest < Minitest::Unit::TestCase
    def test_attributes
      response = ResourceMQ::Response.new
      assert_respond_to response, :status
      assert_respond_to response, :message
      assert_respond_to response, :errors
    end

    def test_message
      response = ResourceMQ::Response.new
      response.message_klass = Products

      response.message.attributes = { name: 'product_name' }

      assert_instance_of Products, response.message
      assert_equal response.message.name, 'product_name'
    end
  end
end
