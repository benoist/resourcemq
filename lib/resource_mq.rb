require "resource_mq/version"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/array/extract_options"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/concern"
require "active_support/dependencies"
require "active_support/dependencies/autoload"
require "active_support/core_ext/module/delegation"
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

