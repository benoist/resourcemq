require 'test_helper'

module ResourceMQ
  class Service
    class Action
      module Testing
        class IndexAction < Action
          attribute :name, String
        end

        class ResourceTest < ActiveSupport::TestCase
          def test_message
            index_action = IndexAction.new
            assert_kind_of Message, index_action
          end
        end
      end
    end
  end
end
