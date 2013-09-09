module ResourceMQ
  class Request
    include Beefcake::Message

    attr_accessor :request_message

    required :service_name, :string, 1
    required :method_name, :string, 2
    required :request_proto, :bytes, 3
  end
end
