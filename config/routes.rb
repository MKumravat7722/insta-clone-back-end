Rails.application.routes.draw do

  resources :users, only: [ :index, :show, :create, :update]

  resources :posts, only: [ :show, :create]
  get 'posts/users/:id',to: 'posts#user_post_by_user'
  # resources :likes, only:[:index,:create]
  resources :posts do
    resources :likes ,only: [:create,:destroy,:show]
  end
  post '/users/:id/follow', to: "users#follow", as: "follow_user"
  post '/users/:id/unfollow', to: "users#unfollow", as: "unfollow_user" 
  resources :notifications, only: [:index]
  
  resources :users do
    resources :posts, only:[:create,:update,:show,:destroy]
  end
  resources :posts do
    resources :comments ,only:[:index,:create]
  end
  get 'comments/:id', to: "comments#show"
  post 'users/login', to: 'authentication#login'

  resources :passwords, only: [:create, :edit, :update], param: :token
  end