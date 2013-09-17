require 'test_helper'

module ResourceMQ
  class Service
    module Testing
      class ServiceTest < ActiveSupport::TestCase
        def test_attributes
          service = Service.new
          assert_respond_to service, :name
          assert_respond_to service, :resources
          assert_kind_of Hash, service.resources
        end

        def test_register_resource
          service = Service.new
          service.register_resource(:products)

          assert_includes service.resources, :products
          assert_kind_of Service::Builder, service.resources[:products]
        end
      end
    end
  end
end
