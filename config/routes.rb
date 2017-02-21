Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  devise_for :users, controllers: {sessions: "users/sessions",
    registrations: "users/registrations"}

  root to: "home#index"

  resources :answers do
    resources :votes
  end

  resources :questions do
    resources :verques, :protques
  end

  resources :comments do
    resources :votes
  end

  resources :users do
    resources :follows, only: :create
  end

  resources :topics do
    resources :fotopics, only: :create
  end

  namespace :admin do
    root "home#index", path: "/"
    resources :users
    resources :topics
    resources :questions
  end
end
