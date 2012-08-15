require 'suggest-api/suggest-api.rb'
require 'sidekiq/web'
require 'http_auth_constraint.rb'

Posterizer::Application.routes.draw do
  
  # Mount the suggestion sinatra API under /suggest
  match '/suggest', :to => SuggestAPI, :anchor => false
  # HTTP auth for sidekiq admin interface
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
  match "exports" => "exports#create", :via => [:post]
  match "users/:handle/export" => "exports#show", :via => [:get]
  get "exports/download"

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
