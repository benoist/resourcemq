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

    attr_accessor :id

    class << self
      def resources(resource_name)
        @resource_name = resource_name
      end

      def resource_name
        (@resource_name || name.underscore.pluralize).to_s
      end

      def request(action, options)
        request = ResourceMQ::Request.new(
            resource:            resource_name,
            action:              action,
            params:              options[:params],
            headers:             {},
            resource_attributes: options[:attributes]
        )
        connection.send_request(request)
      end

      def connection=(connection)
        @connection = connection
      end

      def connection
        if self != Resource
          superclass.connection
        else
          @connection
        end
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
