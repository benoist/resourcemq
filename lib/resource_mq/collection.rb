module ResourceMQ
  module Collection
    extend ActiveSupport::Concern
    include ResourceMQ::Message
    include Enumerable

    def each
      self.items.each
    end
  end
end
