require 'ffi-rzmq'
require 'active_support/all'

Thread.abort_on_exception = true

module Connection
  class Base
    WORKER_ADDRESS = 'inproc://workers'

    def initialize(context = ZMQ::Context.new)
      @context = context
    end

    def encode(object)
      object.to_json
    end

    def decode(message)
      JSON.parse(message)
    end

    def connect_socket(type, address)
      @socket = @context.socket(type)
      @socket.connect(address)
    end

    def receive_message
      @socket.recv_string(message = '')
      decode(message)
    end

    def send_message(message)
      @socket.send_string(encode(message))
    end
  end

  class Worker < Base
    def initialize(context)
      puts 'Starting worker'
      super(context)
      connect_socket(ZMQ::REP, WORKER_ADDRESS)
      listen
    end

    def listen
      loop do
        message  = receive_message
        response = handle_request(message)
        send_message(response)
      end
    end

    def handle_request(request)
      {
          status:  200,
          message: {},
          errors:  {}
      }
    end
  end

  class Server < Base
    attr_accessor :thread_count
    attr_internal :context

    def initialize(thread_count = 1)
      super()
      @thread_count = thread_count
      clients!
      workers!
    end

    def run
      @threads = @thread_count.times.collect { Thread.new { Worker.new(@context) } }
      ZMQ::Device.new(ZMQ::QUEUE, @clients, @workers)
    end

    def clients!
      @clients = @context.socket(ZMQ::ROUTER)
      @clients.bind('tcp://*:5555')
    end

    def workers!
      @workers = @context.socket(ZMQ::DEALER)
      @workers.bind(WORKER_ADDRESS)
    end
  end

  class Client < Base
    def initialize(server_address)
      super()
      connect_socket(ZMQ::REQ, 'tcp://127.0.0.1:5555')
    end

    def send_request(request)
      send_message(request)
      receive_message
    end
  end
end
