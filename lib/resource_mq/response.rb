module ResourceMQ
  class Response
    class MessageKlassMissing < StandardError
    end

    include Message

    attribute :status, Integer
    attribute :message, Hash
    attribute :errors, Hash

    def message
      raise MessageKlassMissing.new unless @message_klass
      @_message ||= @message_klass.new(@message)
    end

    def message_klass=(klass)
      @message_klass = klass
    end
  end
end
