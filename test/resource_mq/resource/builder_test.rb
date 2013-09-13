module Resource
  module Builder
    class ResourceWithCollectionActions < ResourceMQ::Resource::Base
      collection_response :products do
        attribute :page, Integer
        attribute :total, Integer
      end

      collection do
        action :index, respond_with: :products do
          param :page, Integer
        end
      end
    end

    class ResourceWithMemberAction < ResourceMQ::Resource::Base
      member do
        action :show, respond_with: :product
      end
    end

    class CollectionTest < ActiveSupport::TestCase
      def index_action
        ResourceWithCollectionActions.collection_actions[:index]
      end

      def test_collection_action
        assert_equal ResourceWithCollectionActions.collection_actions.count, 1
        assert_kind_of ResourceMQ::Resource::Action, index_action
      end

      def test_action_respond_with
        assert_equal :products, index_action.respond_with
      end

      def test_action_params
        assert_equal index_action.params, {page: Integer}
      end

      def test_collection_method
        assert_respond_to ResourceWithCollectionActions, :index
      end

      def test_collection_responses
        assert_kind_of ResourceMQ::Collection, ResourceWithCollectionActions.collection_responses[:products].new
      end
    end

    class MemberTest < ActiveSupport::TestCase
      def show_action
        ResourceWithMemberAction.member_actions[:show]
      end

      def test_member_action
        assert_equal ResourceWithMemberAction.member_actions.count, 1
        assert_kind_of ResourceMQ::Resource::Action, show_action
      end

      def test_action_respond_with
        assert_equal :product, show_action.respond_with
      end

      def test_collection_method
        assert_respond_to ResourceWithMemberAction, :show
      end

      def test_member_method
        assert ResourceWithMemberAction.method_defined?(:show), 'Expected ResourceWithMemberAction to define method show'
      end
    end
  end
end
