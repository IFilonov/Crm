Rails.application.routes.draw do
  root 'application#index'

  devise_for :clients
  devise_for :staffs

  get '/staffs/staff_email', to: 'staffs#staff_email'
  get '/staffs/staff_logout', to: 'staffs#staff_logout'
  post '/clients/create', to: 'clients#create'
  get '/clients', to: 'clients#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
