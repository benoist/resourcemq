BackendRails::Application.routes.draw do
  resources :products
  get 'ready' => 'application#ready'
end
