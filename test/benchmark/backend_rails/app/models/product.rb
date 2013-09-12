class Product < ActiveRecord::Base
  # we don't want the overhead of a database call right now
  def self.all
    [Product.new({ id: 1, name: "Product1", description: "a nice product description", published: false, price: 10 })]
  end
end
