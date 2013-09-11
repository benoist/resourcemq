module ResourceMQ
  class Connection
    include Virtus

    attribute :connection_request, ResourceMQ::Request
    attribute :connection_response, ResourceMQ::Response

    def self.request(action, options = {})
      new(action, options)
    end

    def initialize(action, options)
      @connection_request = ResourceMQ::Request.new(action: action, params: options[:params])
    end

    def response(response_klass)
      @connection_response               = ResourceMQ::Response.new(message: {})
      @connection_response.message_klass = response_klass
      @connection_response
    end
  end
end
