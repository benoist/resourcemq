module ResourceMQ
  class Server
    def handle_request(data)
      request = ResourceMQ::Request.new(decode(data))
      response = dispatcher.dispatch(request)

      process_response(response)
    end

    def process_response(response)
      encode(response.attributes)
    end

    private

    def encode(hash)
      hash.to_json
    end

    def decode(data)
      JSON.parse(data)
    end

    def dispatcher
      ResourceMQ::Dispatcher
    end
  end
end
