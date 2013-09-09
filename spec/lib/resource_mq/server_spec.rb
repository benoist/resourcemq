require 'spec_helper'

describe ResourceMQ::Server do
  describe '#handle_request' do
    let(:request) { ResourceMQ::Request.new(service_name: 'accounts', method_name: 'show', request_proto: '') }
    let(:encoded_request) { request.encode(buffer = '') && buffer }
    let(:response) { subject.handle_request(encoded_request) }

    before :each do
      ResourceMQ::Service::Dispatcher.stub(:dispatch).and_return(stub(encode: 'response'))
    end

    it 'parses the request' do
      ResourceMQ::Request.should_receive(:decode).with(encoded_request).and_return(request)
      response
    end

    it 'dispatches the request' do
      ResourceMQ::Service::Dispatcher.should_receive(:dispatch).with(request)
      response
    end

    it 'encodes and returns the response' do
      ResourceMQ::Response.new(response_proto: '', status: 200).encode(raw_response = '')
      expect(response).to be == raw_response
    end
  end
end
