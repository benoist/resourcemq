module ResourceMQ
  class Controller
    attr_accessor :request, :response

    delegate :params, :attributes, :headers, to: :request

    def initialize(request, response)
      @request  = request
      @response = response
    end

    protected

    def respond_with(model_or_attributes)
      if model_or_attributes.is_a?(Hash)
        response.message.attributes = model_or_attributes
      elsif model_or_attributes.respond_to?(:attributes)
        response.message.attributes = model_or_attributes.attributes
      end
    end

    def process_action(action)
      self.__send__(action)
    end
  end
end
