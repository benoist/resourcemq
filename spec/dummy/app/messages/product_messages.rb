module ProductMessages
  class Product < ResourceMQ::Message
    serializes ::Product

    required :name, :string
    required :price, :int32
  end

  class List < ResourceMQ::ListMessage
    lists Product
  end
end
