class ClientsController < ApplicationController

  before_action :authenticate_staff!, only: [:create, :index]
  before_action :authenticate_client!, only: [:client_email, :client_logout]

  def index
    render :json => Client.all.pluck_all(:fullname, :email, :phone)
  end

  def create
    password_length = 6
    password = Devise.friendly_token.first(password_length)
    client = Client.new(client_params)
    client.password = password
    client.password_confirmation = password
    client.save!
  end

  def client_email
    render :json => {:client_email => current_client.email }
  end

  def client_logout
    sign_out current_client
    redirect_to root_path
  end

  def companies
    render :json => current_client.companies.includes(:juristic_type).pluck_all(:name, '"juristic_types"."name" as jur_type', :inn, :ogrn)
  end

  private
  def client_params
    params.require(:client).permit(:fullname, :email, :phone)
  end
end
