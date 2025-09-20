Rails.application.routes.draw do
  resources :users, only: %i[index show create update destroy] do 
    collection do
      get 'search'
      get 'search_history'
    end
  end

  resources :posts
  get 'posts/users/:id', to: 'posts#user_post_by_user'

  resources :posts, only: [] do
    resource :likes, only: %i[create destroy]
  end

  resources :notifications, only: [:index]

  resources :posts, only: [] do
    resources :comments, only: %i[create destroy]
  end

  resources :follows, only: [] do
    member do
      post :follow
      delete :unfollow
    end
  end

  post 'users/login', to: 'authentication#login'

  resources :passwords, only: %i[create update], param: :token
  resources :stories, only: %i[index create destroy]
end
