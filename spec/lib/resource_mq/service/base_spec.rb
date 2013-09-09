require 'spec_helper'

class PostService < ResourceMQ::Service::Base
  attr_accessor :call_stack

  def initialize(*)
    super
    @call_stack = []
  end

  def index
    @call_stack << :index
  end
end

describe PostService do
  describe '#call' do
    subject do
      service = described_class.new
      service.call('request', 'response', :index)
      service
    end

    it 'calls the public action' do
      expect(subject.call_stack).to be == [:index]
    end

    it 'sets the request' do
      expect(subject.request).to be == 'request'
    end

    it 'sets the response' do
      expect(subject.response).to be == 'response'
    end

    it 'raises an exception if method is not public' do
      expect {
        subject.call(:uncallable)
      }.to raise_exception
    end
  end

  describe '#respond_with' do
    let(:response_message) { ResourceMQ::Message.new }
    let(:object) { Struct.new(:username).new('username') }

    subject do
      service          = described_class.new
      service.response = response_message
      service.respond_with object
    end

    it 'sets the object on the response message' do
      response_message.should_receive('object=').with(object)
      subject
    end
  end
end
