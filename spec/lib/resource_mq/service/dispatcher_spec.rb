require 'spec_helper'

module AccountMessages
  class Show < ResourceMQ::Message
    required :id, :int32
  end

  class Account < ResourceMQ::Message
    required :username
  end
end

class AccountsService < ResourceMQ::Service::Base
  def show
    response.username = 'username'
    response
  end
end

describe ResourceMQ::Service::Dispatcher do
  let(:request_proto) do
    AccountMessages::Show.new(id: 1).encode(request_proto = '')
    request_proto
  end

  let(:request) { ResourceMQ::Request.new(service_name: 'accounts', method_name: 'show', request_proto: request_proto) }

  subject { described_class.new(request) }

  before :each do
    ResourceMQ::Service::Router.route do
      service :accounts do
        action :show, returns: :account
      end
    end
  end

  describe '.dispatch' do
    it 'dispatches the request' do
      described_class.any_instance.should_receive(:dispatch)
      described_class.dispatch(request)
    end
  end

  describe '#service' do
    it 'returns the service' do
      expect(subject.service).to be_a(AccountsService)
    end
  end

  describe '#action' do
    it 'return the action name' do
      expect(subject.action).to be == 'show'
    end
  end

  describe '#request_message' do
    it 'returns the decoded request proto' do
      expect(subject.request_message).to be_a AccountMessages::Show
    end
  end

  describe '#response_message' do
    it 'returns the response message' do
      expect(subject.response_message).to be_a AccountMessages::Account
    end
  end

  describe '#dispatch' do
    it 'calls the service method' do
      subject.service.
          should_receive(:call).
          with(subject.request_message, subject.response_message, 'show')
      subject.dispatch
    end

    it 'returns the updated response' do
      subject.dispatch
      expect(subject.response_message).to be == AccountMessages::Account.new(username: 'username')
    end
  end
end
