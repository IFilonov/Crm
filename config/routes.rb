Rails.application.routes.draw do
  devise_for :clients, controllers: { sessions: 'clients/sessions' }
  devise_for :staffs, controllers: { sessions: 'staffs/sessions'  }

  authenticated :client do
    root 'clients#index', as: :authenticated_client
  end
  authenticated :staff do
    root 'staffs#index', as: :authenticated_staff
  end

  root 'application#index'

  get '/staffs/staff_logout', to: 'staffs#staff_logout'
  get '/clients/client_logout', to: 'clients#client_logout'

  constraints ->(req) { req.format == :json } do
    get '/staffs/staff_email', to: 'staffs#staff_email'
    post '/clients/create', to: 'clients#create'
    get '/clients', to: 'clients#clients_all'
    get '/clients/client_email', to: 'clients#client_email'
    post '/clients/id', to: 'clients#client'
    get '/client/companies', to: 'clients#companies'
    get '/companies', to: 'companies#index'
    post '/clients/delete', to: 'clients#delete'
    post '/companies/delete', to: 'companies#delete'
    post '/companies/create', to: 'companies#create'
    get '/juristic_types', to: 'juristic_types#index'
    post '/companies/client_companies', to: 'companies#client_companies'
    patch '/clients/update', to: 'clients#update'
    patch '/clients/reset', to: 'clients#reset'
    patch '/clients_companies/rebind_companies_to_client', to: 'clients_companies#rebind_companies_to_client'
    patch '/companies/update', to: 'companies#update'
    post '/companies/clients', to: 'companies#clients'
    patch '/companies/rebind_refs_data', to: 'companies#rebind_refs_data'
    post '/devices/create', to: 'devices#create'
    get '/devices', to: 'devices#index'
    post '/devices/id', to: 'devices#device'
    post '/devices/delete', to: 'devices#delete'
    patch '/devices/update', to: 'devices#update'
    post '/devices/id', to: 'devices#device'
    post '/companies/devices', to: 'companies#devices'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  get '/staffs/*slug', to: 'staffs#index'
  get '/clients/*slug', to: 'clients#index'
end
