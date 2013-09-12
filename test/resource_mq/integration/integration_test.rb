require 'test_helper'

module Integration
  class ProductsController < ResourceMQ::Controller::Base
    def index
      respond_with page: 1, total: 1
    end

    def show
      respond_with name: 'name', description: 'description'
    end
  end

  class Product < ResourceMQ::Resource
    class << self
      def index(params = {})
        request(:index, params: params)
      end

      def show(id)
        request(:show, params: {id: id})
      end
    end

    def reload
      self.class.show(id)
    end
  end

  class IntegrationTest < ActiveSupport::TestCase
    def setup
      server                          = ResourceMQ::Server.new
      ResourceMQ::Resource.connection = ResourceMQ::Client::Test.new(server)
    end

    def test_collection_method
      response = Product.index(page: 1)
      assert_equal response, {status: 200, message: {page: 1, total: 1}, errors: {}}
    end

    def test_member_method
      product    = Product.new
      product.id = 1
      response   = product.reload

      product.persisted?
      assert_equal response, {status: 200, message: {name: 'name', description: 'description'}, errors: {}}
    end
  end

  class ComplianceTest < MiniTest::Unit::TestCase
    include ActiveModel::Lint::Tests

    def setup
      @model = Product.new
    end
  end
end
