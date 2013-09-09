module ResourceMQ
  class Response
    include Beefcake::Message

    required :response_proto, :bytes, 1
    required :status, :int32, 2
    #optional :error, Error, 3
  end
end
