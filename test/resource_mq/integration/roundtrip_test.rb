require 'test_helper'

module Integration
  class Product < ResourceMQ::Resource::Base
    attribute :name, String
    attribute :description, String
    attribute :price_in_cents, Integer

    collection_response :products do
      attribute :page, Integer
      attribute :total, Integer

      has_many :items, Product
    end

    collection do
      action :index, respond_with: Product::Products
    end

    class << self
      def index(params = {})
        request(:index, params: params, respond_with: Product::Products)
      end

      def show(id)
        request(:show, params: {id: id})
      end
    end

    def reload
      request(:show)
    end
  end

  class ProductsController < ResourceMQ::Controller::Base
    def index
      respond_with page: 1, total: 1, items: [{id: 1, name: 'name', description: 'description', price_in_cents: 100}]
    end

    def show
      respond_with id: 1, name: 'name', description: 'description', price_in_cents: 100
    end
  end

  class RountripTest < ActiveSupport::TestCase
    def setup
      server                                = ResourceMQ::Server.new
      ResourceMQ::Resource::Base.connection = ResourceMQ::Client::Test.new(server)
    end

    def test_collection_method
      response = Product.index(page: 1)

      assert_equal response.page, 1
      assert_equal response.total, 1

      product = response.items.first
      assert_equal product.id, 1
      assert_equal product.name, 'name'
      assert_equal product.description, 'description'
      assert_equal 100, product.price_in_cents
    end

    def test_member_method
      product    = Product.new
      product.id = 1
      product.reload

      assert_equal product.name, 'name'
      assert_equal product.description, 'description'
      assert_equal product.price_in_cents, 100
    end
  end
end
