module ResourceMQ
  class Resource
    class ParamNotPermitted < StandardError
    end
    class ParamTypeMismatch < StandardError
    end

    include Virtus
    extend  ActiveModel::Naming
    extend  ActiveModel::Translation
    include ActiveModel::Conversion

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

      def collection(&block)
        block.call
      end

      def action(name, response_klass, &block)
        @_action = name
        method_contents = block.call

        if @_attributes && @_attributes[@_action]
          define_method('load_errors') do |response|
            response.errors.each do |key, value|
              response.message.errors.set(key, [value])
            end
          end

          define_method(name) do
            action = name
            connection = Connection.request(name.to_sym)
            response = connection.response(response_klass[:responds_with])
            load_errors(response)
            response.message
          end
        else
          self.class.instance_eval do
            define_method(name) do |params = {}|
              action = name
              valid_params?(action, params)
              connection = Connection.request(name.to_sym, params: params)
              connection.response(response_klass[:responds_with]).message
            end
          end
        end
      end

      def valid_params?(action, given_params)
        true if given_params.empty? || given_params.nil?
        given_params.each do |param, type|
          raise ParamNotPermitted.new(param) unless @_params[action][param]
          raise ParamTypeMismatch.new(param) unless type.is_a?(@_params[action][param])
        end
      end

      def params(name, type)
        @_params ||= Hash.new { |h,k| h[k] = {} }
        @_params[@_action][name] = type
      end

      def attributes_for(klass)
        @_attributes ||= Hash.new { |h,k| h[k] = {} }
        @_attributes[@_action][klass] = klass.attribute_set.inject({}) do |result, attribute|
          result[attribute.name.to_s] = attribute.class.name.split('::').last.constantize
          result
        end
      end
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end
end
