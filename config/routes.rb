Rails.application.routes.draw do
  get 'stations/index'
  get 'stations/show'
  root to: 'pages#home'
  resources :stations do
    resources :reviews, only: [:create]
  end
  resources :reviews, only: [:update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
