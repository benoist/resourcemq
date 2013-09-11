require "resource_mq/version"
require "active_support/all"
require "virtus"
require "forwardable"
require 'active_model'


module ResourceMQ
  extend ActiveSupport::Autoload

  autoload :Request
  autoload :Message
  autoload :Response
  autoload :Resource
  autoload :TestConnection
  autoload :Connection

  module Controller
    extend ActiveSupport::Autoload

    autoload :Callbacks
    autoload :Metal
    autoload :Responder
    autoload :Base
  end

  autoload :Dispatcher

  class Dispatcher
    extend ActiveSupport::Autoload
    autoload :Resource
    autoload :Action
  end
end

