require 'resource_mq/version'
require 'active_support/all'
require 'virtus'
require 'forwardable'
require 'active_model'
require 'ffi-rzmq'


module ResourceMQ
  extend ActiveSupport::Autoload

  autoload :Request
  autoload :Message
  autoload :Response
  autoload :Resource
  autoload :Server

  module Client
    extend ActiveSupport::Autoload

    autoload :Test
  end

  module Controller
    extend ActiveSupport::Autoload

    autoload :Callbacks
    autoload :Metal
    autoload :Responder
    autoload :Base
  end

  autoload :Dispatcher
end

