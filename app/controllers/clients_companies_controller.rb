class ClientsCompaniesController < ApplicationController
  before_action :authenticate_staff!, only: [:update]
  before_action :find_client, only: [:update]

  def update
    @client.clients_companies.destroy_all
    clients_companies_update_params.each do |company|
      ClientsCompany.create(client_id: @client.id, company_id: company)
    end
  end

  private
  def find_client
    @client = Client.find(params[:client_id])
  end

  def clients_companies_update_params
    params.permit(company_ids: [])[:company_ids]
  end
end
