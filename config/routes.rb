Rails.application.routes.draw do
  root 'application#index'

  devise_for :clients
  devise_for :staffs

  get '/staffs/staff_email', to: 'staffs#staff_email'
  get '/staffs/staff_logout', to: 'staffs#staff_logout'
  post '/clients/create', to: 'clients#create'
  get '/clients', to: 'clients#index'
  get '/clients/client_email', to: 'clients#client_email'
  get '/clients/client_logout', to: 'clients#client_logout'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
