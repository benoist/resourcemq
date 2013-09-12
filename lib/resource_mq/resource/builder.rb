module ResourceMQ
  module Resource
    module Builder
      def collection_response(name, &block)
        klass = Class.new
        self.const_set("#{name.to_s.camelize}", klass)

        klass.send(:include, Collection)
        klass.instance_exec &block

        collection_responses[name] = klass
      end

      def collection_responses
        @_collection_responses ||= {}
      end
    end
  end
end
