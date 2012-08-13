require "suggest-api/suggest-api.rb"
require 'sidekiq/web'

Posterizer::Application.routes.draw do
  
  # Mount the suggestion sinatra API under /suggest
  match '/suggest', :to => SuggestAPI, :anchor => false
  mount Sidekiq::Web => '/sidekiq'

  #Active Admin
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  # Resources
  resources :users
  resources :posters, :only => [:destroy, :create]
  match 'posters/:id/destroy', :to => 'posters#destroy'
  match 'users/:handle/update', :to => 'users#update'
  match 'users/:handle/request_export', :to => "users#request_export"
  
  # Session routes
  get 'sessions/create'
  match 'login' => redirect('/auth/facebook'), :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout

  #Facebook oauth paths
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')

  root :to => 'pages#landing'
  match '/about', :to => 'pages#about'
  match '/terms', :to => 'pages#terms'

  match '/:handle', to: 'users#show', :as => :user
end
