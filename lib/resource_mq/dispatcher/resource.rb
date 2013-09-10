module ResourceMQ
  class Dispatcher
    class Resource
      include ResourceMQ::Message

      attr_accessor :actions, :headers

      class << self
        def register(name, &block)
          klass = Class.new(self)
          klass.instance_exec &block if block_given?
          klass.new(name)
        end
      end

      def initialize(name, &block)
        @_name = name
      end

      def resource_name
        @_name
      end
    end
  end
end
