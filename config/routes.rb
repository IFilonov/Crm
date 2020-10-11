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
  get '/clients/companies', to: 'clients#companies'
  get '/companies', to: 'companies#index'
  post '/clients/delete', to: 'clients#delete'
  post '/companies/delete', to: 'companies#delete'
  post '/companies/create', to: 'companies#create'
  get '/juristic_types', to: 'juristic_types#index'
  post '/companies/client_companies', to: 'companies#client_companies'
  patch '/clients/update', to: 'clients#update'
  patch '/clients_companies/client_companies', to: 'clients_companies#client_companies'
  patch '/companies/update', to: 'companies#update'
  post '/companies/company_clients', to: 'companies#company_clients'
  patch '/clients_companies/company_clients', to: 'clients_companies#company_clients'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
