Rails.application.routes.draw do
  resources :laboratory_examinations
  resources :radiologists
  resources :status_schedules
  resources :survey_monkey_customers
  resources :survey_monkeys
  resources :customer_surveys
  get 'third_dashboard/index'
  get 'third_dashboard/third_db_data'
  get 'second_dashboard/index'
  get 'first_dashboard/index'
  get 'customer_satisfication/index'
  get 'home/index'
  get 'second_dashboard/towns'
  get 'second_dashboard/filter'
  get 'customer_satisfication/filterapply'
  get 'service_provider/index'
 
  resources :first_dashboard ,only: [:index] do 
    collection do
      match 'excel_generate', to: 'first_dashboard#excel_generate', via: [:get, :post], defaults: { format: :xlsx }

      # post '/excel_generate',to: "first_dashboard#excel_generate" , defaults: { format: :xlsx } 
    end 
  end
   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end