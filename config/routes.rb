Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # ログインしてない時のパス
  root 'articles#index'

  # マイページ
  get 'my_page/profile'
  get 'my_page/participating_event'

  devise_for :users
  resources :articles do
    resources :participants, only: [:create, :destroy] # 参加
    resources :favorites, only: [:create, :destroy] # お気に入り
  end

  resources :inquiries, only: [:create]
end
