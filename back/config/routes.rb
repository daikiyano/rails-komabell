Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do
      namespace :mypage do
        resource :user_images, only: [:update]
        resource :my_pages, only: [:index,:update]
      end
      namespace :myskill do
        resource :user_skill_categories, only: [:index,:create,:update]
        get 'user_skill_categories/index'
      end
      # put 'my_pages/update' =>  "my_pages#update"
      # get 'my_pages/index'
      #Sign Up用のみ
      get "/fetch_categories", to: "skill_categories#fetch_categories"
      get "/search/:book_category", to: "books#search"
      get 'books/:isbn' => 'books#show'
      resource :users, only: [:create]
      post "/create", to: "auth#create"
      post "/signin", to: "auth#signin"
      post "/login", to: "auth#login"
      post "/token_check", to: "auth#token_check"
      get "/auto_login", to: "auth#auto_login"
      get "/user_is_authed", to: "auth#user_is_authed"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
