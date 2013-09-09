module ResourceMQ
  class Resource
    include Virtus

    class << self
      def resources(resource_name, &block)
        @resource_name = resource_name
        block.call
      end

      def resource_name
        @resource_name.to_s
      end

      def collection_response(collection_name, &block)
        collection_object = Class.new
        self.const_set("#{collection_name.to_s.camelize}", collection_object)

        collection_object.send(:include, Message)
        collection_object.instance_exec &block

        collection_responses[collection_name] = collection_object
      end

      def collection_responses
        @collection_responses ||= {}
      end
    end

  end
end
