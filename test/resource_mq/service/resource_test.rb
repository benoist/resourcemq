require 'test_helper'

module ResourceMQ
  class Service
    class Resource
      module Testing
        class ProductResource < Resource
          attribute :name, String
        end

        class ResourceTest < ActiveSupport::TestCase
          def test_message
            product = ProductResource.new
            assert_kind_of Message, product
          end

          def test_collection_response
            ProductResource.collection_response :products

            assert_includes ProductResource.collection_responses, :products
            assert_operator ProductResource.collection_responses[:products], :<=, CollectionResponse
          end
        end
      end
    end
  end
end
