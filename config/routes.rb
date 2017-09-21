Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # ログインしてない時のパス
  root 'articles#index'

  # マイページ
  get 'my_page/profile' # プロフィール
  get 'my_page/articles' # 自分の投稿
  get 'my_page/favorites' # お気に入り投稿
  get 'my_page/participations' # 参加しているオフ会

  devise_for :users
  resources :articles do
    resources :participants, only: [:create, :destroy] # 参加
    resources :favorites, only: [:create, :destroy] # お気に入り
    resources :messages, only: [:index, :create]
  end

  resources :inquiries, only: [:create]
end
