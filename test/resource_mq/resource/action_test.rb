require 'test_helper'

module Resource
  module Action
    class ActionTest < ActiveSupport::TestCase
      def action
        @action ||= ResourceMQ::Resource::Action.new('index', :collection, nil)
      end

      def test_params
        action.attributes = {}
        action.param :page, Integer
        assert_equal({page: Integer}, action.params)
        action.attributes = {name: String}
        assert_raises(ResourceMQ::Resource::Action::AttributeWithParamsException) do
          action.param :page, Integer
        end
      end

      def test_attribute
        action.params = {}
        action.attribute :name, String
        assert_equal({name: String}, action.attributes)
        action.params = {page: Integer}
        assert_raises(ResourceMQ::Resource::Action::AttributeWithParamsException) do
          action.attribute :name, String
        end
      end

      def test_attributes?
        action.params     = {}
        action.attributes = {name: String}
        assert action.attributes?
      end

      def test_params?
        action.attributes = {}
        action.params     = {page: Integer}
        assert action.params?
      end
    end
  end
end
