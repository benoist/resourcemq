require 'spec_helper'

describe ResourceMQ::Request do
  subject { described_class.new(service_name: 'service', method_name: 'method', request_proto: '') }
  it 'requires the service name' do
    expect {
      subject.service_name = nil
      subject.validate!
    }.to raise_error
    expect(subject).to respond_to(:service_name)
  end

  it 'requires the method name' do
    expect {
      subject.method_name = nil
      subject.validate!
    }.to raise_error
    expect(subject).to respond_to(:method_name)
  end

  it 'requires the request proto' do
    expect {
      subject.request_proto = nil
      subject.validate!
    }.to raise_error
    expect(subject).to respond_to(:request_proto)
  end

  it 'allows encoding and decoding' do
    subject.encode(buffer = '')
    decoded = described_class.decode(buffer)
    expect(decoded).to be == subject
  end
end
