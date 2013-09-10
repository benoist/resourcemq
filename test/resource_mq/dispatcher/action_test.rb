require 'test_helper'

module Dispatcher
  module Action
    class ActionTest < ActiveSupport::TestCase
      def test_attributes
        @action = ResourceMQ::Dispatcher::Action.new

        assert_respond_to @action, :params
        assert_respond_to @action, :attributes
      end
    end
  end
end
