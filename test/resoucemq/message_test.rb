require 'test_helper'

class MessageDummy
  include ResourceMQ::Message
  attribute :name, String
  has_many :tags, String

  attr_accessor :extra
end

class MessageDummyTest < MiniTest::Unit::TestCase
  def message_dummy
    MessageDummy.new(name: 'name', tags: %w(big nothing))
  end

  def test_attribute
    assert_includes message_dummy.attributes.keys, :name
    assert_instance_of String, message_dummy.name
  end

  def test_has_many
    assert_includes message_dummy.attributes.keys, :tags
    assert_instance_of Array, message_dummy.tags
  end

  def test_initialize
    message_dummy = MessageDummy.new(name: 'name', tags: %w(big nothing))
    assert_equal message_dummy.name, 'name'
    assert_equal message_dummy.tags, %w(big nothing)
  end

  def test_to_hash
    assert_equal message_dummy.to_hash, {
        name: 'name',
        tags: %w(big nothing)
    }
  end
end
