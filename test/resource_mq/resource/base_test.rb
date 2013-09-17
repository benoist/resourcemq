require 'test_helper'

module ResourceMQ
  module Resource
    class Base
      module Testing
        class Product < ResourceMQ::Resource::Base
        end

        class ResourceTest < ActiveSupport::TestCase
          def setup
            @model = Product.new
          end

          def test_resource_name
            assert_equal Product.resource_name, "#{self.class.parent_name}/products".underscore
            Product.resources(:fancy_products)
            assert_equal Product.resource_name, 'fancy_products'
          end

          def test_id
            assert Product.method_defined?(:id)
          end
        end
      end
    end
  end
end
