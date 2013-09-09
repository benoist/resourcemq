module ResourceMQ
  class Message
    class InvalidObjectClass < StandardError
    end

    attr_accessor :object

    include Beefcake::Message

    class << self
      def serializes(klass = nil)
        @serializes ||= klass
      end

      def required(*args)
        options         = args.extract_options!
        field, type, fn = *args
        super(field, type, fn || fields.count + 1, options)
        delegate_if_exists(field)
      end

      def repeated(*args)
        options         = args.extract_options!
        field, type, fn = *args
        super(field, type, fn || fields.count + 1, options)
        delegate_if_exists(field)
      end

      def optional(*args)
        options         = args.extract_options!
        field, type, fn = *args
        super(field, type, fn || fields.count + 1, options)
        delegate_if_exists(field)
      end

      def delegate_if_exists(field)
        return unless serializes && serializes.method_defined?(field)
        define_method field do
          instance_variable_get("@#{field}") || object && object.send(field)
        end
      end

      def fields
        if superclass <= ResourceMQ::Message
          @fields ||= superclass.fields.dup
        else
          @fields ||= {}
        end
      end
    end

    optional :id, :int32, 1

    def id
      if @object.respond_to?(:id)
        @object.id
      else
        @id
      end
    end

    def object=(object)
      if object.instance_of?(self.class.serializes)
        @object = object
      else
        raise InvalidObjectClass.new("Object class invalid expected #{self.class.serializes} got: #{object.class}")
      end
    end
  end
end
