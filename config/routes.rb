Rails.application.routes.draw do
  resources :tasks
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
 
  resources :users do
    collection {post :import}
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      # 1か月分の変更申請
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      # 1か月分の勤怠申請
      get 'attendances/edit_one_month_request'
      patch 'attendances/update_month_request'
      # 出勤社員一覧
      get 'working_list'
    end
    resources :attendances, only: [:update] do
      member do
        # 残業申請
        get 'edit_overwork'
        patch 'update_overwork'
        # 残業承認
        get 'edit_overwork_notice'
        patch 'update_overwork_notice'
        # 勤怠承認
        get 'edit_attendance_change'
        patch 'update_attendance_change'
        # 1か月分の承認
        get 'edit_one_month_approval'
        patch 'update_one_month_approval'
        # 勤怠ログ
        get 'log_page'
      end
    end
  end

  resources :bases
end