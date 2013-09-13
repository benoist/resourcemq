module ResourceMQ
  module Resource
    module Builder
      class CollectionBuilder
        def self.build(klass, &block)
          builder = new(klass)
          builder.instance_exec(&block)
          builder.define_methods
        end

        def initialize(klass)
          @klass = klass
        end

        def action(name, options = {}, &block)
          action = Action.new(name, :collection, options[:respond_with])
          action.instance_exec(nil, &block) if block_given?
          @klass.collection_actions[name] = action
        end

        def define_methods
          class_methods    = Module.new
          instance_methods = Module.new
          @klass.collection_actions.each do |_, action|
            if action.attributes?
              class_methods.send(:define_method, action.name) do |attributes|
                request(action.name, attributes: attributes, respond_with: action.respond_with)
              end
            elsif action.params?
              class_methods.send(:define_method, action.name) do |params|
                request(action.name, params: params, respond_with: action.respond_with)
              end
            else
              class_methods.send(:define_method, action.name) do
                request(action.name, respond_with: action.respond_with)
              end
            end
          end

          @klass.send(:extend, class_methods)
          @klass.send(:include, instance_methods)
        end
      end

      def collection_responses
        @_collection_responses ||= {}
      end

      def collection_actions
        @_collection_actions ||= {}
      end

      private

      def collection_response(name, &block)
        klass = Class.new
        self.const_set("#{name.to_s.camelize}", klass)

        klass.send(:include, Collection)
        klass.instance_exec &block

        collection_responses[name] = klass
      end

      def collection(&block)
        CollectionBuilder.build(self, &block)
      end
    end
  end
end
