require 'test_helper'

module ResourceMQ
  module IntegrationTest
    class Product < Resource::Base
      resources self.name.pluralize

      attribute :name, String
      attribute :description, String
      attribute :price_in_cents, Integer

      collection_response :products do
        attribute :page, Integer
        attribute :total, Integer

        has_many :items, Product
      end

      collection do
        action :index, respond_with: Product::Products do
          param :page, Integer
        end
      end

      member do
        action :show
      end

      def reload
        request(:show)
      end
    end

    ResourceMQ.service = Service.new

    #ResourceMQ.service.register_resource :product do
    #  attribute :name, String
    #  attribute :description, String
    #  attribute :price_in_cents, Integer
    #
    #  collection_response :products do
    #    attribute :page, Integer
    #    attribute :total, Integer
    #
    #    has_many :items, Product
    #  end
    #
    #  collection do
    #    action :index, respond_with: Product::Products do
    #      param :page, Integer
    #    end
    #  end
    #
    #  member do
    #    action :show
    #  end
    #end

    class ProductsController < Controller::Base
      def index
        respond_with page: 1, total: 2, items: [{id: 1, name: 'name', description: 'description', price_in_cents: 100},
                                                {id: 2, name: 'name', description: 'description', price_in_cents: 100}]
      end

      def show
        respond_with id: 1, name: 'name', description: 'description', price_in_cents: 100
      end
    end

    class RountripTest < ActiveSupport::TestCase
      def setup
        server                    = Server.new
        Resource::Base.connection = Client::Test.new(server)
      end

      def test_collection_method
        response = Product.index(page: 1)

        assert_equal 1, response.page
        assert_equal 2, response.total
        assert_instance_of Product, response.items.first
        assert_instance_of Product, response.items.last

        product = response.items.first
        assert_equal product.id, 1
        assert_equal product.name, 'name'
        assert_equal product.description, 'description'
        assert_equal 100, product.price_in_cents
      end

      def test_member_method
        product    = Product.new
        product.id = 1
        product.show

        assert_equal product.name, 'name'
        assert_equal product.description, 'description'
        assert_equal product.price_in_cents, 100
      end

      def test_custom_method
        product    = Product.new
        product.id = 1
        product.reload

        assert_equal product.name, 'name'
        assert_equal product.description, 'description'
        assert_equal product.price_in_cents, 100
      end
    end
  end
end
