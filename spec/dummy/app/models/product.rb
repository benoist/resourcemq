class Product < Struct.new(:name, :price)
  def self.all
    [Product.new('test', 1)]
  end
end
