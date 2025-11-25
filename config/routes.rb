Rails.application.routes.draw do
  get 'settings/index'
  devise_for :users

  root "homes#index"
  resources :meals

  get 'settings', to: 'settings#index'
end
