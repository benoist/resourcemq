require 'test_helper'

module Resource
  class Product < ResourceMQ::Resource::Base
  end

  class ResourceTest < ActiveSupport::TestCase
    def setup
      @model = Product.new
    end

    def test_resource_name
      assert_equal Product.resource_name, 'resource/products'
      Product.resources(:fancy_products)
      assert_equal Product.resource_name, 'fancy_products'
    end

    def test_id
      assert Product.method_defined?(:id)
    end
  end

  class ComplianceTest < MiniTest::Unit::TestCase
    include ActiveModel::Lint::Tests

    def setup
      @model    = Product.new
      @model.id = 1
    end
  end
end
