Rails.application.routes.draw do
  # 暫時把任務列表設為根目錄
  root 'tasks#index'

  resources :tasks

end
