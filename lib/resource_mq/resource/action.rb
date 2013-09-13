module ResourceMQ
  module Resource
    class Action
      class AttributeWithParamsException < StandardError; end

      attr_accessor :name, :type, :respond_with, :params, :attributes

      def initialize(name, type, respond_with)
        @name         = name
        @type         = type
        @respond_with = respond_with
        @params       = {}
        @attributes   = {}
      end

      def param(name, type)
        raise AttributeWithParamsException.new('You cannot use actions with params and attributes') if attributes?
        params[name] = type
      end

      def attribute(name, type)
        raise AttributeWithParamsException.new('You cannot use actions with params and attributes') if params?
        attributes[name] = type
      end

      def attributes?
        @attributes.any?
      end

      def params?
        @params.any?
      end
    end
  end
end
