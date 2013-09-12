module ResourceMQ
  module Resource
    module Connection
      extend ActiveSupport::Concern

      class InvalidResponseClass < StandardError;
      end

      def request(action)
        request = self.class.build_request(action, params: {id: id}, attributes: attributes)
        response = connection.send_request(request)
        handle_response(response)
      end

      def handle_response(response)
        self.attributes = response.message
        self
      end

      def connection
        self.class.connection
      end

      module ClassMethods
        def request(action, options)
          request  = build_request(action, options)
          response = connection.send_request(request)
          handle_response(response, options[:respond_with])
        end

        def build_request(action, options)
          ResourceMQ::Request.new(
              resource:            resource_name,
              action:              action,
              params:              options[:params],
              headers:             {},
              resource_attributes: options[:attributes]
          )
        end

        def connection=(connection)
          @connection = connection
        end

        def connection
          @connection ||= if self != Base
            superclass.connection
          else
            @connection
          end
        end

        protected

        def handle_response(response, respond_with)
          if respond_with
            class_name = "#{self.name}/#{respond_with}".camelize
            klass      = class_name.safe_constantize
          else
            klass = self
          end

          raise InvalidResponseClass.new("#{class_name} does not exists") unless klass

          klass.new(response.message)
        end
      end
    end
  end
end
