Rails.application.routes.draw do
  # 暫時把任務列表設為根目錄
  root 'tasks#index'

  # task 的 CRUD routes
  resources :tasks
end
