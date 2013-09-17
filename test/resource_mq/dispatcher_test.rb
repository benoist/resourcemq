require 'test_helper'

module ResourceMQ
  class Dispatcher
    module Testing
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
          request    = Request.new(resource: "#{self.class.parent_name}/products", action: 'index')
          dispatcher = Dispatcher.new(request)
          response   = dispatcher.dispatch

          assert_equal response, 'processed: index'
          assert_equal dispatcher.controller.request, request
        end
      end
    end
  end
end
