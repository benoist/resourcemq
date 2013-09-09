module ResourceMQ
  class Server
    def worker
      @worker ||= Majordomo::Worker.new('tcp://0.0.0.0:5555', 'echo')
    end

    def run
      loop do
        request = worker.receive_message(reply_to = '')
        response = handle_request(request.first)
        worker.send_message([response], reply_to)
      end
    end

    def handle_request(raw)
      request = ResourceMQ::Request.decode(raw)
      Service::Dispatcher.dispatch(request).encode(response_message = '')
      ResourceMQ::Response.new(response_proto: response_message, status: 200).encode(raw_response = '')
      raw_response
    end
  end
end
