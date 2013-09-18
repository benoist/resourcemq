module ResourceMQ
  class Service
    class Response
      include Message

      class << self
        def build(name, &block)
          @name = name.to_s.singularize
          self
        end
      end
    end
  end
end
