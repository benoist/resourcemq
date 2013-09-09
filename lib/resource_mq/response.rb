module ResourceMQ
  class Response
    include Message

    attribute :status, Integer
    attribute :message, Hash
    attribute :errors, Hash

    def message
      @_message ||= @message_klass ? @message_klass.new(@message) : @message
    end

    def message_klass=(klass)
      @message_klass = klass
    end
  end
end
