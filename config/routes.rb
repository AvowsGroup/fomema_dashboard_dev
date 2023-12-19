Rails.application.routes.draw do
  resources :refresh_dashboards
  resources :laboratory_examinations
  resources :radiologists
  resources :status_schedules
  resources :survey_monkey_customers
  resources :survey_monkeys
  resources :customer_surveys
  get 'home/index'
  get 'geographical/towns'
  get 'geographical/filter'
  get 'customer_satisfaction/filterapply'

  namespace :dashboards do
    get 'fw_information/index', to: 'fw_information#index'
    namespace :fw_information do
      get 'index'
      get 'apply_filter'
    end
    get 'geographical', to: 'geographical#index'
    namespace :geographical do
      get 'index'
      get 'towns'
      get 'filter'
    end
    get 'dep_information', to: 'dep_information#index'
    namespace :dep_information do
      get 'third_db_data'
      get 'index'
      get 'filter_kpi'
    end
    get 'customer_satisfaction', to: 'customer_satisfaction#index'
    namespace :customer_satisfaction do
      get 'filterapply'
      get 'index'
    end
    get 'service_provider', to: 'service_provider#index'
    namespace :service_provider do
      get 'index'
      get 'apply_filter'
    end
    resources :fw_information, only: [:index] do
      collection do
        match 'excel_generate', to: 'fw_information#excel_generate', via: [:get, :post], defaults: { format: :xlsx }
      end
    end

    resources :department_information, only: [:new] do
      collection do
        post 'calculate_kpi'
        patch 'update_kpi', to: 'department_information#update_kpi'
      end
    end

    resources :department_configuration, except: [:show] do
      collection do
        get 'edit', to: 'department_configuration#edit'
        get 'audit_logs', to: 'department_configuration#audit_logs'
      end
    end
  end

  namespace :settings do
    get 'customer_survey_upload', to: 'customer_survey_upload#index'
    post 'customer_survey_upload' => "customer_survey_upload#import"
  end

end


