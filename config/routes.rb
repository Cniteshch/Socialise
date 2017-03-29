Rails.application.routes.draw do
  root to: 'posts#index'
  devise_for :users
  resources :users do
    member do
      get :follow
      get :unfollow
    end
  end
  resources :posts do 
  	member do
    put "like", to: "posts#like"
    put "unlike", to: "posts#unlike"
   
    end
    resources :comments 
  end
end
