module ResourceMQ
  class Service
    attr_accessor :name, :resources

    def initialize
      @resources = {}
    end

    def register_resource(name, &block)
      @resources[name] = Resource.build(name, &block)
    end
  end
end
