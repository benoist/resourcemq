require 'test_helper'

module ResourceMQ
  class ResourcesDummy
    def initialize(options = {})
    end
  end

  class ResourceDummy
    include Virtus

    attribute :name, String
    attribute :description, String
    attribute :price_in_cents, Integer
    attribute :published_at, Time

    def initialize(option = {})
    end
  end

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

      collection do
        action :index, responds_with: ResourcesDummy do
          params :page, Integer
          params :total, Integer
        end

        action :create, responds_with: ResourceDummy do
          attributes_for ResourceDummy
        end
      end
    end
  end

  class ResourceTest < MiniTest::Unit::TestCase
    def setup
      @product = Product.new
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

    def test_index
      assert_instance_of ResourcesDummy, Product.index(page: 1, total: 1)
    end

    def test_param_not_permitted
      exception = assert_raises(ResourceMQ::Resource::ParamNotPermitted) do
        Product.index(wrong_param: 123)
      end
      assert_equal 'wrong_param', exception.message
    end

    def test_type_mismatch
      exception = assert_raises(ResourceMQ::Resource::ParamTypeMismatch) do
        Product.index(page: '1')
      end
      assert_equal 'page', exception.message
    end

    def test_create
      params = {
        name: 'Pepsi',
        description: 'Sugar water',
        price_in_cents: '250',
        published_at: Time.now
      }
      product = Product.new(params)
      assert_instance_of ResourceDummy, product.create
    end
  end

  class ComplianceTest < MiniTest::Unit::TestCase
    include ActiveModel::Lint::Tests

    def setup
      @model = Product.new
    end
  end
end
