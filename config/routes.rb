Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # Userログイン時
  authenticated :user do
    root to: 'articles#index'
  end
  # ログインしてない時のパス
  root 'articles#index'

  # マイページ
  get 'my_page/profile'
  get 'my_page/participating_event'

  devise_for :users
  resources :articles do
    resources :participants, only: [:create, :destroy]
  end

  resources :inquiries, only: [:create]
end
