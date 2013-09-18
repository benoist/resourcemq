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
  autoload :Collection
  autoload :Response
  autoload :Server
  autoload :Service
  autoload :Dispatcher

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

  module Resource
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Builder
    autoload :Connection
    autoload :Action
  end

  class Service
    extend ActiveSupport::Autoload

    autoload :Resource
    autoload :Action
    autoload :Response
    autoload :CollectionResponse
  end

  mattr_accessor :service
end

