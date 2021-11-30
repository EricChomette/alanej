Rails.application.routes.draw do
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # post 'stations/index-recup', to: "stations#create_from_sortable"
  root to: 'pages#home'
  resources :stations do
    resources :reviews, only: [:create]
  end
  resources :reviews, only: [:update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
