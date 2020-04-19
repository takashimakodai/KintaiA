Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  #　追加管理機能
  get '/currently_working', to: 'users#currently_working'
  get '/basic_information', to: 'users#basic_information'
  
  # 拠点機能
  resources :bases
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/edit_overtime_info'
      patch 'attendances/request_overtime'
      get 'attendances/news_overtime'
      patch 'attendances/reply_overtime'
      get 'attendances/change_information'
      patch 'attendances/reply_change_info'
      get 'attendances/approval_info'
      patch 'attendances/reply_approval_info'
    end
    resources :attendances, only: :update 
  end
end
