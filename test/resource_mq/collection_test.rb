require 'test_helper'

module ResourceMQ
  module Collection
    module Testing
      class CollectionDummy
        include ResourceMQ::Collection

        attribute :page, Integer
      end

      class CollectionTest < ActiveSupport::TestCase
        def setup
          @collection = CollectionDummy.new(page: '1')
        end

        def test_attributes
          assert_equal @collection.page, 1
        end

        def test_enumerable
          assert_kind_of Enumerable, @collection
          assert_respond_to @collection, :each
        end
      end
    end
  end
end
