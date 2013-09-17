module ResourceMQ
  class Service
    attr_accessor :name, :resources

    def initialize
      @resources = {}
    end

    def register_resource(name)
      @resources[name] = Builder.new(name)
    end
  end
end
