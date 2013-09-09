module ResourceMQ
  module Message
    extend ActiveSupport::Concern
    include Virtus

    module ClassMethods
      def has_many(name, klass)
        attribute name, Array[klass]
      end
    end
  end
end
