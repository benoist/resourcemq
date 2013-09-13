module ResourceMQ
  module Resource
    module Builder
      class CollectionBuilder
        def self.build(klass, &block)
          builder = new(klass)
          builder.instance_exec(&block)
          klass.define_methods
        end

        def initialize(klass)
          @klass = klass
        end

        def action(name, options = {}, &block)
          action = Action.new(name, :collection, options[:respond_with])
          action.instance_exec(nil, &block) if block_given?
          @klass.collection_actions[name] = action
        end
      end

      class MemberBuilder
        def self.build(klass, &block)
          builder = new(klass)
          builder.instance_exec(&block)
          klass.define_methods
        end

        def initialize(klass)
          @klass = klass
        end

        def action(name, options = {}, &block)
          action = Action.new(name, :member, options[:respond_with])
          action.instance_exec(nil, &block) if block_given?
          @klass.member_actions[name] = action
        end
      end

      def define_methods
        class_methods    = Module.new
        instance_methods = Module.new
        collection_actions.each do |_, action|
          next if class_methods.method_defined?(action.name)
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

        member_actions.each do |_, action|
          next if class_methods.method_defined?(action.name)
          if action.attributes?
            class_methods.send(:define_method, action.name) do |attributes|
              request(action.name, params: {id: id}, attributes: attributes, respond_with: action.respond_with)
            end
          else
            class_methods.send(:define_method, action.name) do
              request(action.name, params: {id: id}, respond_with: action.respond_with)
            end
          end
          instance_methods.send(:define_method, action.name) do
            request(action.name)
          end
        end

        extend class_methods
        include instance_methods
      end

      def collection_responses
        @_collection_responses ||= {}
      end

      def collection_actions
        @_collection_actions ||= {}
      end

      def member_actions
        @_member_actions ||= {}
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
        define_methods
      end

      def member(&block)
        MemberBuilder.build(self, &block)
        define_methods
      end
    end
  end
end
