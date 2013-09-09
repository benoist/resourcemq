require 'test_helper'

module ResourceMQ
  class Product < ResourceMQ::Resource
    resources :products do
      attribute :name, String
      attribute :description, String
      attribute :price_in_cents, Integer
      attribute :published_at, Time

      # response :fancy_product do
      #   attribute :fance_name, String
      # end

      collection_response :products do
        # collection_of :product # this is default :products.singularize
        attribute :page, Integer
        attribute :total, Integer
      end
    end

  end

  class ResourceTest < MiniTest::Unit::TestCase
    def setup
      @product = Product.new
      @model = Product.new
    end

    def test_attributes
      %w(name description price_in_cents published_at).each do |attribute|
        assert_includes @product.attributes.keys, attribute.to_sym
      end
      assert_equal 'products', Product.resource_name
    end

    def test_collection_response
      @products = Product::Products.new
      %w(page total).each do |attribute|
        assert_includes @products.attributes.keys, attribute.to_sym
      end
    end
  end

  class Compliance < MiniTest::Unit::TestCase
    include ActiveModel::Lint::Tests

    def setup
      @model = Product.new
    end
  end
end
