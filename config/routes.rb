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
    end
    # 残業申請
    resources :attendances do
      member do
        get 'edit_overtime_info'
      end
    end
  end
end
