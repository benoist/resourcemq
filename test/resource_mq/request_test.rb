require 'test_helper'

class ProductsHeader
  include ResourceMQ::Message
  attribute :remote_ip, String
  attribute :trace_id, Integer
end

module ResourceMQ
  class Request
    module Testing

      class RequestTest < Minitest::Unit::TestCase
        def test_attributes
          request = Request.new
          assert_respond_to request, :resource
          assert_respond_to request, :action
          assert_respond_to request, :headers
          assert_respond_to request, :params
          assert_respond_to request, :attributes
        end

        def test_abstract_message
          request = Request.new(resource: 'products', headers: {non_existing: 'anything', remote_ip: '127.0.0.1', trace_id: '1'})

          assert_equal request.headers.remote_ip, '127.0.0.1'
          assert_equal request.headers.trace_id, 1
          assert_equal request.instance_variable_get(:@headers)[:non_existing], 'anything'
          refute_respond_to request.headers, :non_existing
        end

        def test_headers
          request = Request.new
          assert_instance_of Hash, request.headers
          request = Request.new(resource: 'products')
          assert_instance_of ProductsHeader, request.headers
        end
      end
    end
  end
end
