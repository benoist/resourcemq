module ResourceMQ
  class Response
    class MessageKlassMissing < StandardError
    end

    include Message

    attribute :status, Integer
    attribute :message, Hash
    attribute :errors, Hash
  end
end
