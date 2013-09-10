require 'test_helper'

module Controller
  module Responder
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

    class ProductsController < ResourceMQ::Controller::Base
      def index
        response.status = 200
      end
    end

    class ResponderTest < ActiveSupport::TestCase
      def setup
        @controller          = ProductsController.new
        @controller.request  = @request = ResourceMQ::Request.new
        @controller.response = @response = ResourceMQ::Response.new
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
end
