module ResourceMQ
  class Request < Message
    attribute :resource, String
    attribute :action, String
    attribute :headers, Hash
    attribute :params, Hash
    attribute :resource_attributes, Hash

    def headers
      header_klass.new(@headers)
    end

    def params
      @params
    end

    def resource_attributes
      @resource_attributes
    end

    private

    def header_klass
      "#{@resource.camelize}Header".constantize
    end
  end
end
