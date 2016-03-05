BloomGroup::Application.routes.draw do
resources :reports, only: [:new, :index]

  concern :enable_disable do
    patch :enable, :disable, on: :member
  end

  resources :employees_roles, except: [:show, :update, :edit, :new], concerns: :enable_disable
  resources :employee_call_out, only: :update do
    member do
      post :duplicate
    end
  end

  resources :facilities, except: :show, concerns: :enable_disable do
    resources :shifts
    resources :call_out_shifts, only: [:update, :create] do
      resources :call_out_lists, only: [:show, :create]
    end
  end
  
  post "employees/:id/notes", to: "employees#create_note"
  get "seniority", to: "employees#seniority"
  post "seniority", to: "employees#seniority_update"
  get "facility/:facility_id/shift_occurrences/:shift_id/:date", to: "shift_occurrences#show", as: :facility_shift_occurrence
  get 'schedules/:facility_id(/:start_date)', to: 'schedules#show', as: :facility_schedule
  get 'schedules', to: 'schedules#index'
  resources :employees, except: :show , concerns: :enable_disable
  resources :employees, except: :show do
    collection { post :import }
    resources :notes
  end
  get  "employees/:employee_id/availability", to: "availabilities#edit", as: :edit_employee_availability
  post "employees/:employee_id/availability", to: "availabilities#update", as: :update_employee_availability


  authenticated :user do
    root :to => 'schedules#index', :as => :authenticated_root
  end

  devise_for :users
  resources :users, concerns: :enable_disable
  root :to => redirect('/users/sign_in')
end
