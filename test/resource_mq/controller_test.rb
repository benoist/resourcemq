require 'test_helper'

module Controller
  class ProductModel < Struct.new(:name, :description)
    def attributes
      {name: name, description: description}
    end
  end

  class Product
    include ResourceMQ::Message

    attribute :name, String
  end

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
  end

  class RespondWithTest < Minitest::Unit::TestCase
    def setup
      @request    = ResourceMQ::Request.new
      @response   = ResourceMQ::Response.new
      @controller = ProductsController.new(@request, @response)
    end

    def test_respond_with_attributes
      @response.message_klass = Products
      @controller.send(:respond_with, page: 1, total: 1)
      assert_equal @response.message.page, 1
      assert_equal @response.message.total, 1
    end

    def test_respond_with_model
      @response.message_klass = Product
      @controller.send(:respond_with, ProductModel.new('name', 'description'))
      assert_equal @response.message.name, 'name'
    end

    def test_status
      @response.message_klass = Product
      @controller.send(:respond_with, status: :success)
      assert_equal @response.status, 200
      @controller.send(:respond_with, status: :unprocessable_entity)
      assert_equal @response.status, 422
    end
  end
end
