Rails.application.routes.draw do
  get 'settings/index'
  devise_for :users

  root "homes#index"
  resources :meals
  resources :meals do
    resources :comments, only: :create
  end

  get 'settings', to: 'settings#index'
end
