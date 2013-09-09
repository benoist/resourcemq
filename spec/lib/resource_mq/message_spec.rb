require 'spec_helper'

class Account < Struct.new(:username, :email, :actions)
  def id
    @id ||= rand(1000)
  end
end

class AccountMessage < ResourceMQ::Message
  serializes Account

  required :username, :string
  optional :email, :string
  repeated :actions, :string
  repeated :other_actions, :string, packed: true
end

describe AccountMessage do
  let(:account) { Account.new('username', 'email', 'actions') }
  subject { described_class.new.tap { |s| s.object = account } }

  describe '.serializes' do
    it 'registers the class for serialization' do
      expect(AccountMessage.serializes).to be == Account
    end
  end

  describe '#id' do
    it 'responds to id' do
      expect(subject.id).to be == account.id
    end
  end

  describe '#object=' do
    it 'raises an error if the object does not have the right class' do
      expect {
        subject.object = Object.new
      }.to raise_error(described_class::InvalidObjectClass)
    end
  end

  describe '#to_hash' do
    it 'returns a hash with attributes' do
      expect(subject.to_hash).to be == {
          id: account.id,
          username: 'username',
          email: 'email',
          actions: 'actions'
      }
    end
  end

  describe 'required optional repeated' do
    it 'registers the fields for message serialization' do
      expect(AccountMessage.fields).to be == {
          1 => Beefcake::Message::Field.new(:optional, :id, :int32, 1, {}),
          2 => Beefcake::Message::Field.new(:required, :username, :string, 2, {}),
          3 => Beefcake::Message::Field.new(:optional, :email, :string, 3, {}),
          4 => Beefcake::Message::Field.new(:repeated, :actions, :string, 4, {}),
          5 => Beefcake::Message::Field.new(:repeated, :other_actions, :string, 5, packed: true)
      }
    end

    it 'delegates the fields getters to the object' do
      expect(subject.email).to be == 'email'
      expect(subject.username).to be == 'username'
      expect(subject.actions).to be == 'actions'
    end

    it 'does not create delegations if the serialization class does not respond' do
      expect {
        subject.other_actions = %w(new_actions)
      }.not_to raise_exception
      expect(subject.other_actions).to be == %w(new_actions)
    end
  end

  describe 'encoding and decoding' do
    it 'encodes and decodes the message' do
      subject.other_actions = %w(other)
      subject.encode(buffer = '')

      message = AccountMessage.decode(buffer)
      
      expect(message.to_hash).to be == {
          id: account.id,
          username: account.username,
          email: account.email,
          actions: %w(actions),
          other_actions: %w(other)
      }
    end
  end
end
