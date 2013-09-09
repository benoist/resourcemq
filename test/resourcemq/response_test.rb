require 'test_helper'

class ResponseTest < Minitest::Unit::TestCase
  def test_attributes
    response = ResourceMQ::Response.new
    assert_respond_to response, :status
    assert_respond_to response, :message
    assert_respond_to response, :errors
  end
end
