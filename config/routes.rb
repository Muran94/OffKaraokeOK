Rails.application.routes.draw do
  namespace :articles do
    get 'inquiries/create'
  end

  root 'static_pages#home'

  get 'static_pages/home'

  devise_for :users
  resources :articles
end
