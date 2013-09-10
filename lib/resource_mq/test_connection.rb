module ResourceMQ
  class TestConnection
    class << self
      def stub(resource, action, response)
        stubbed_resource = stubbed_resources[resource] ||= {}
        stubbed_resource[action] = response
      end

      def stubbed_resources
        @stubbed_resources ||= {}
      end

      def send_request(request)
        resource = request.resource
        action   = request.action
        stubbed_resources[resource][action]
      end
    end
  end
end
