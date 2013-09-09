module ResourceMQ
  module Service
    class Router
      class << self
        def route(&block)
          clear
          @routing = block
        end

        def action_return_type(service, action)
          routes[service][action].to_s.camelize
        end

        def routes
          @routes ||= build_routes
        end

        def clear
          @routes = nil
        end

        private

        def build_routes
          @_routes            = {}.with_indifferent_access
          @_current_namespace = []
          instance_exec &@routing
          @_routes
        end

        def service(name, &block)
          @_current_namespace.push(name)

          @_routes[@_current_namespace.join('/')] = {}.with_indifferent_access

          instance_exec &block

          @_current_namespace.pop
        end

        def namespace(name, &block)
          @_current_namespace.push(name)

          instance_exec &block

          @_current_namespace.pop
        end

        def action(name, options)
          @_routes[@_current_namespace.join('/')][name] = options[:returns]
        end
      end
    end
  end
end
