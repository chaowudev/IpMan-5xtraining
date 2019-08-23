Rails.application.routes.draw do

  root 'sessions#new'

  resources :users, only: %i[new create]
  resources :sessions, only: %i[new create destroy]
  resources :tasks
  
  namespace :admin, path: 'IpMan2019-admin' do
    resources :users
  end
  # get '/sign-up', to: 'users#new'
  # get '/log-in', to: 'sessions#new'
  # get '/log-out', to: 'sessions#destroy'

  %w[404 500].each do |code|
    get code, to: "errors#show", code: code
  end

end
