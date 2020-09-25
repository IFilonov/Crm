class ClientsController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    clients = Client.all
  end

  def create
    password_length = 6
    password = Devise.friendly_token.first(password_length)
    client = Client.new(client_params)
    client.password = password
    client.password_confirmation = password
    client.save!
  end

  private
  def client_params
    params.permit(:fullname, :email, :phone)
  end
end
