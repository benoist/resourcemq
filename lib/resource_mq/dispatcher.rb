module ResourceMQ
  class Dispatcher
    attr_internal :request

    class << self
      def dispatch(request)
        new(request).dispatch
      end
    end

    def initialize(request)
      @_request = request
    end

    def dispatch
      controller.request = request
      controller.process(action)
    end

    def controller
      @_controller ||= controller_klass.new
    end

    private

    def controller_klass
      @_controller_klass ||= controller_name.safe_constantize || raise("Controller #{controller_name} not found")
    end

    def controller_name
      "#{request.resource.camelize}Controller"
    end

    def action
      request.action
    end
  end
end
