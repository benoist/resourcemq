module Resource
  module Collection
    class ResourceWithCollection < ResourceMQ::Resource::Base
      collection_response :products do
        attribute :page, Integer
        attribute :total, Integer
      end
    end

    class CollectionResponseTest < ActiveSupport::TestCase
      def test_collection_responses
        assert_kind_of ResourceMQ::Collection, ResourceWithCollection.collection_responses[:products].new
      end
    end
  end
end
