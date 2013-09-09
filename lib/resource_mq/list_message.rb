module ResourceMQ
  class ListMessage < Message
    class InvalidListObjectClass < InvalidObjectClass
    end

    repeated :items, Object, 1

    class << self
      def lists(klass = nil)
        return @lists if @lists && !klass
        @lists = klass
        repeated :items, klass, 1
      end
    end

    def object=(object)
      if object.respond_to?(:to_ary)
        @object = object.to_ary
        set_items
      else
        raise InvalidListObjectClass.new("List object class invalid expected Array got: #{object.class}")
      end
    end

    private

    def set_items
      item_klass = self.class.lists
      @items = object.collect do |o|
        item_klass.new.tap { |i| i.object = o }
      end
    end
  end
end
