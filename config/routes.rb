Rails.application.routes.draw do
  devise_for :users

  root "homes#index"

  resources :meals do
    collection do
      get 'filter'
    end
    resources :comments, only: [:create, :destroy]
  end

  resources :memos, only: [:index, :create, :destroy] do
    patch :toggle_pin, on: :member
  end

  get 'settings', to: 'settings#index'
end
