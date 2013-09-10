module ResourceMQ
  module Controller
    module Callbacks
      extend ActiveSupport::Concern
      include ActiveSupport::Callbacks

      included do
        define_callbacks :process_action,
                         terminator: 'response',
                         skip_after_callbacks_if_terminated: true
      end

      def process_action(*args)
        run_callbacks(:process_action) do
          super
        end
      end

      module ClassMethods
        def _normalize_callback_options(options)
          _normalize_callback_option(options, :only, :if)
          _normalize_callback_option(options, :except, :unless)
        end

        def _normalize_callback_option(options, from, to) # :nodoc:
          if from = options[from]
            from        = Array(from).map { |o| "action_name == '#{o}'" }.join(" || ")
            options[to] = Array(options[to]).unshift(from)
          end
        end

        def _insert_callbacks(callbacks, block = nil)
          options = callbacks.extract_options!
          _normalize_callback_options(options)
          callbacks.push(block) if block
          callbacks.each do |callback|
            yield callback, options
          end
        end

        def before_action(*names, &blk)
          _insert_callbacks(names, blk) do |name, options|
            set_callback(:process_action, :before, name, options)
          end
        end

        def prepend_before_action(*names, &blk)
          _insert_callbacks(names, blk) do |name, options|
            set_callback(:process_action, :before, name, options.merge(:prepend => true))
          end
        end

        def skip_before_action(*names)
          _insert_callbacks(names) do |name, options|
            skip_callback(:process_action, :before, name, options)
          end
        end

        def after_action(*names, &blk)
          _insert_callbacks(names, blk) do |name, options|
            set_callback(:process_action, :after, name, options)
          end
        end

        def prepend_after_action(*names, &blk)
          _insert_callbacks(names, blk) do |name, options|
            set_callback(:process_action, :after, name, options.merge(:prepend => true))
          end
        end

        def skip_after_action(*names)
          _insert_callbacks(names) do |name, options|
            skip_callback(:process_action, :after, name, options)
          end
        end

        def around_action(*names, &blk)
          _insert_callbacks(names, blk) do |name, options|
            set_callback(:process_action, :around, name, options)
          end
        end

        def prepend_around_action(*names, &blk)
          _insert_callbacks(names, blk) do |name, options|
            set_callback(:process_action, :around, name, options.merge(:prepend => true))
          end
        end

        def skip_around_action(*names)
          _insert_callbacks(names) do |name, options|
            skip_callback(:process_action, :around, name, options)
          end
        end
      end
    end
  end
end
