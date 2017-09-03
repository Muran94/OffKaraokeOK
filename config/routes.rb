Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Userログイン時
  authenticated :user do
    root to: 'articles#index'
  end
  # ログインしてない時のパス
  root 'static_pages#home'

  get 'static_pages/home'

  devise_for :users
  resources :articles do
    resources :participants, only: [:create, :destroy]
  end
end
