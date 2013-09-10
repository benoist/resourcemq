require 'test_helper'

module Controller
  module Callbacks
    class Callback1 < ResourceMQ::Controller::Base
      before_action :first
      after_action :second
      around_action :aroundz

      def first
        @text = "Hello world"
      end

      def second
        @second = "Goodbye"
      end

      def aroundz
        @aroundz = "FIRST"
        yield
        @aroundz << "SECOND"
      end

      def index
        @text         ||= nil
        self.response = @text.to_s
      end
    end

    class Callback1Overwrite < Callback1
      before_action :first, except: :index
    end

    class TestCallbacks2 < ActiveSupport::TestCase
      def setup
        @controller = Callback1.new
      end

      test "before_action works" do
        @controller.process(:index)
        assert_equal "Hello world", @controller.response
      end

      test "after_action works" do
        @controller.process(:index)
        assert_equal "Goodbye", @controller.instance_variable_get("@second")
      end

      test "around_action works" do
        @controller.process(:index)
        assert_equal "FIRSTSECOND", @controller.instance_variable_get("@aroundz")
      end

      test "before_action with overwritten condition" do
        @controller = Callback1Overwrite.new
        @controller.process(:index)
        assert_equal "", @controller.response
      end
    end

    class CallbacksTest < ActiveSupport::TestCase

    end
  end
end
