class ProductsController < ApplicationController

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end
end