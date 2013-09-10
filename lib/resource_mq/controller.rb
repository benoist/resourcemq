module ResourceMQ
  class Controller
    STATUS_CODES = {
        success:              200,
        created:              201,
        bad_request:          400,
        unprocessable_entity: 422
    }.freeze

    attr_accessor :request, :response

    delegate :params, :attributes, :headers, to: :request

    def initialize(request, response)
      @request  = request
      @response = response
    end

    protected

    def respond_with(*args)
      options    = args.extract_options!
      status     = status_code(options.delete(:status))
      errors     = options.delete(:errors) || {}
      model      = args.first

      if model.respond_to?(:attributes)
        attributes = model.attributes
      else
        attributes = options
      end

      response.status             = status
      response.errors             = errors
      response.message.attributes = attributes
    end

    def process_action(action)
      self.__send__(action)
    end

    def status_code(name_or_code)
      STATUS_CODES["#{name_or_code}".to_sym] || 200
    end
  end
end
