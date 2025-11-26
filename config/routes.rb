Rails.application.routes.draw do
  devise_for :users

  root "homes#index"

  resources :meals do
    collection do
      get 'filter'
    end
    resources :comments, only: [:create, :destroy]
  end

  get 'settings', to: 'settings#index'
end
