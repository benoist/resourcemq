class ProductsService < ResourceMQ::Service::Base
  def index
    @products = Product.all

    respond_with @products
  end

  def show
  end

  def create
  end

  def update

  end

  def destroy

  end
end
