require 'librmdp'
require 'resource_mq'

ActiveSupport::Dependencies.autoload_paths << File.expand_path('../../app/services', __FILE__)
ActiveSupport::Dependencies.autoload_paths << File.expand_path('../../app/models', __FILE__)
ActiveSupport::Dependencies.autoload_paths << File.expand_path('../../app/messages', __FILE__)

require_relative './services'
