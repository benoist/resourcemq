require 'test_helper'

module Dispatcher
  module Resource
    class ResourceTest < ActiveSupport::TestCase
      def test_register
        resource = ResourceMQ::Dispatcher::Resource.register('products') do
          attribute :name, String
          attribute :price_in_cents, Integer
        end

        resource.attributes = {name: 'iMac', price_in_cents: '100'}

        assert_equal resource.resource_name, 'products'
        assert_equal resource.name, 'iMac'
        assert_equal resource.price_in_cents, 100
        assert_kind_of ResourceMQ::Dispatcher::Resource, resource
      end

      def test_attributes
        @resource = ResourceMQ::Dispatcher::Resource.new('products')

        assert_respond_to @resource, :actions
        assert_respond_to @resource, :headers
        assert_respond_to @resource, :attributes
      end
    end
  end
end
