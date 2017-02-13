Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  devise_for :users, controllers: {sessions: "users/sessions",
    registrations: "users/registrations"}

  root to: "home#index"

  resources :answers

  resources :questions

  resources :comments

  resources :users

end
