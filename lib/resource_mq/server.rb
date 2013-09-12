module ResourceMQ
  class Server
    def handle_request(request)
      response = dispatcher.dispatch(request)
      process_response(response)
    end

    def process_response(response)
      response
    end

    private

    def dispatcher
      ResourceMQ::Dispatcher
    end
  end
end
