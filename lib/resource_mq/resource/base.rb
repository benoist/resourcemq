module ResourceMQ
  module Resource
    class Base
      class ParamNotPermitted < StandardError
      end
      class ParamTypeMismatch < StandardError
      end

      include Virtus
      extend ActiveModel::Naming
      extend ActiveModel::Translation
      include ActiveModel::Conversion

      extend Builder
      include Connection

      attr_accessor :id

      class << self
        def resources(resource_name)
          @resource_name = resource_name
        end

        def resource_name
          (@resource_name || name.underscore.pluralize).to_s
        end
      end

      def errors
        @errors ||= ActiveModel::Errors.new(self)
      end

      def persisted?
        id.present?
      end

      def to_key
        persisted? ? id : nil
      end
    end
  end
end
