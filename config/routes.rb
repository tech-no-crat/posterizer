require "suggest-api/suggest-api.rb"

Posterizer::Application.routes.draw do
  
  # Mount the suggestion sinatra API under /suggest
  match '/suggest', :to => SuggestAPI, :anchor => false

  #Active Admin
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  # Resources
  resources :users
  resources :posters, :only => [:destroy, :create]
  match 'posters/:id/destroy', :to => 'posters#destroy'
  match 'users/:handle/update', :to => 'users#update'
  
  # Session routes
  get 'sessions/create'
  match 'login' => redirect('/auth/facebook'), :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout

  #Facebook oauth paths
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')

  root :to => 'pages#landing'

  match '/:handle', to: 'users#show', :as => :user
end
