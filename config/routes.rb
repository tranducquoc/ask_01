Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  devise_for :users, controllers: {sessions: "users/sessions",
    registrations: "users/registrations"}

  root to: "home#index"

  resources :answers do
    resources :votes
  end

  resources :questions

  resources :comments do
    resources :votes
  end

  resources :users

  resources :topics do
    resources :fotopics, only: :create
  end

end
