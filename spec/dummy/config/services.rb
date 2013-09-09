ResourceMQ::Service::Router.route do
  service :products do
    action :index, returns: :list
    action :show, returns: :product
    action :create, returns: :product
    action :update, returns: :product
    action :destroy, returns: :product
  end
end
