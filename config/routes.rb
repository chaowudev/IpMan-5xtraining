Rails.application.routes.draw do

  root 'sessions#new'

  resources :tasks
  resources :users
  resources :sessions
  
  # get '/sign-up', to: 'users#new'
  # get '/log-in', to: 'sessions#new'
  # get '/log-out', to: 'sessions#destroy'

end
