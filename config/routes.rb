require "suggest-api/suggest-api.rb"

Posterizer::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config, ActiveAdmin::Devise.config

  match '/suggest', :to => SuggestAPI, :anchor => false

  resources :users
  match 'login' => redirect('/auth/facebook'), :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout

  root :to => 'pages#landing'

  resources :posters, :only => [:destroy, :create]
  match 'posters/:id/destroy', :to => 'posters#destroy'

  get 'sessions/create'

   #Facebook oauth paths
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
end
