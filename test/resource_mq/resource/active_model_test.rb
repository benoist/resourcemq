require 'test_helper'

module Resource
  module ActiveModel
    class Product < ResourceMQ::Resource::Base
    end

    class ComplianceTest < MiniTest::Unit::TestCase
      include ::ActiveModel::Lint::Tests

      def setup
        @model = Product.new
      end
    end
  end
end
