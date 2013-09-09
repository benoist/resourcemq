module ResourceMQ
  class Response < Message
    attribute :status, Integer
    attribute :message, Hash
    attribute :errors, Hash
  end
end
