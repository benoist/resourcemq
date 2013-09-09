module ResourceMQ
  class Controller
    attr_accessor :request, :response

    delegate :params, :attributes, :headers, to: :request

    def initialize(request, response)
      @request  = request
      @response = response
    end

    protected

    def process_action(action)
      self.__send__(action)
    end
  end
end
