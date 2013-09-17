require 'test_helper'

module ResourceMQ
  class Response
    module Testing
      class Products
        include Message

        attribute :name, String
      end

      class ResponseTest < Minitest::Unit::TestCase
        def test_attributes
          response = Response.new
          assert_respond_to response, :status
          assert_respond_to response, :message
          assert_respond_to response, :errors
        end
      end
    end
  end
end
