Rails.application.routes.draw do
  resources :users, only: %i[index show create update]

  resources :posts, only: %i[show create]
  get 'posts/users/:id', to: 'posts#user_post_by_user'
  # resources :likes, only:[:index,:create]
  resources :posts do
    resources :likes, only: %i[create destroy show]
  end
  post '/users/:id/follow', to: 'users#follow', as: 'follow_user'
  post '/users/:id/unfollow', to: 'users#unfollow', as: 'unfollow_user'
  resources :notifications, only: [:index]

  resources :users do
    resources :posts, only: %i[create update show destroy]
  end
  resources :posts do
    resources :comments, only: %i[index create]
  end
  get 'comments/:id', to: 'comments#show'
  post 'users/login', to: 'authentication#login'

  # resources :passwords, only: [:new, :create, :edit, :update]
  get 'passwords/new', to: 'passwords#new', as: 'new_password'
  post 'passwords', to: 'passwords#create', as: 'passwords'
  get 'passwords/edit/:token', to: 'passwords#edit', as: 'edit_password'
  post 'passwords/:token', to: 'passwords#update', as: 'password'
end
