require 'test_helper'

module Dispatcher
  class Dispatcher1 < ResourceMQ::Dispatcher
  end

  Dispatcher1.resources do
    resource :products do
      attribute :name, String
      attribute :price_in_cents, Integer
    end
  end

  class DispatcherTest < ActiveSupport::TestCase
    def test_resource
      assert_includes Dispatcher1.registered_resources, :products
      assert_kind_of ResourceMQ::Dispatcher::Resource, Dispatcher1.registered_resources[:products]

      resource = Dispatcher1.registered_resources[:products]
      resource.attributes = {name: 'iMac', price_in_cents: '100'}

      assert_equal resource.name, 'iMac'
      assert_equal resource.price_in_cents, 100
    end
  end
end
