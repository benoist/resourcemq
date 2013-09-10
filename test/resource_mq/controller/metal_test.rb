require 'test_helper'

module Controller
  module Metal
    class ProductsController < ResourceMQ::Controller::Base
      def index
        response.status = 200
      end
    end

    class MetalTest < ActiveSupport::TestCase
      def setup
        @controller          = ProductsController.new
        @controller.request  = @request = ResourceMQ::Request.new
        @controller.response = @response = ResourceMQ::Response.new
      end

      def test_request_delegations
        assert_equal @controller.attributes, @request.attributes
        assert_equal @controller.params, @request.params
        assert_equal @controller.headers, @request.headers
      end

      def test_process_action
        @controller.send(:process_action, :index)
        assert_equal @response.status, 200
      end
    end
  end
end
