Posterizer::Application.routes.draw do
  resources :users

  root :to => 'pages#landing'

   #Facebook oauth paths
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
end
