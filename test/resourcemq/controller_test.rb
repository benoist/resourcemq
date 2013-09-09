require 'test_helper'

module Controller
  class Products
    include ResourceMQ::Message

    attribute :page, Integer
    attribute :total, Integer
  end

  class ProductsController < ResourceMQ::Controller
    def index
      response.status = 200
    end
  end

  class ControllerTest < Minitest::Unit::TestCase
    def setup
      @request    = ResourceMQ::Request.new
      @response   = ResourceMQ::Response.new
      @controller = ProductsController.new(@request, @response)
    end

    def test_initialize
      assert_equal @controller.request, @request
      assert_equal @controller.response, @response
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

    def test_respond_with
      #@controller.send(:respond_with, )
    end
  end
end
