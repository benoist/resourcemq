require 'test_helper'

module Dispatcher
  class ProductsController
    def request=(request)
      @request = request
    end

    def request
      @request
    end

    def process(action_name)
      "processed: #{action_name}"
    end
  end

  class DispatcherTest < ActiveSupport::TestCase
    def test_dispatch
      request = ResourceMQ::Request.new(resource: 'dispatcher/products', action: 'index')
      dispatcher = ResourceMQ::Dispatcher.new(request)
      response = dispatcher.dispatch

      assert_equal response, 'processed: index'
      assert_equal dispatcher.controller.request, request
    end
  end
end
