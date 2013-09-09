module ResourceMQ
  class Response
    include Message
    attribute :status, Integer
    attribute :message, Hash
    attribute :errors, Hash
  end
end
