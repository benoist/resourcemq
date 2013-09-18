module ResourceMQ
  class Service
    class Resource
      include Message

      class << self
        def build(name, &block)
          @name = name.to_s.singularize
          self
        end

        def name
          @name
        end

        def collection_response(name, &block)
          collection_responses[name] = CollectionResponse.build(name, &block)
        end

        def collection_responses
          @collection_responses ||= {}
        end
      end
    end
  end
end
