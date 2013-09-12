Frontend::Application.routes.draw do
  resources :products, only: [:index]
  get 'ready' => 'application#ready'
end
