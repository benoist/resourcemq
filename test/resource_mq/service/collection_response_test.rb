require 'test_helper'

module ResourceMQ
  class Service
    class CollectionResponse < Response
      module Testing
        class ProductsCollection < CollectionResponse
          attribute :page, Integer
        end

        class ResourceTest < ActiveSupport::TestCase
          def test_message
            product = ProductsCollection.new
            assert_kind_of Message, product
          end
        end
      end
    end
  end
end
