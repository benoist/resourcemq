module ResourceMQ
  class Message
    include Virtus

    class << self
      def has_many(name, klass)
        attribute name, Array[klass]
      end
    end
  end
end
