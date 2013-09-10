module ResourceMQ
  class Dispatcher
    class << self
      def resources(&block)
        instance_exec &block
      end

      def resource(name, &block)
        register_resource(name, Resource.register(name, &block))
      end

      def registered_resources
        @_registered_resources ||= {}
      end

      private

      def register_resource(name, resource)
        registered_resources[name] = resource
      end
    end
  end
end
