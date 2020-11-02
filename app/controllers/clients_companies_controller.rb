class ClientsCompaniesController < ApplicationController
  before_action :authenticate_staff!, only: [:rebind_companies_to_client]
  before_action :find_client, only: [:rebind_companies_to_client]

  def rebind_companies_to_client
    new_companies_params.each do |company|
      @client.clients_companies.create(company_id: company)
    end
    del_companies_params.each do |company|
      @client.clients_companies.find_by(company_id: company).destroy
    end
  end

  private
  def find_client
    @client = Client.find(params[:client_id])
  end

  def new_companies_params
    params.permit(new_company_ids: [])[:new_company_ids]
  end

  def del_companies_params
    params.permit(del_company_ids: [])[:del_company_ids]
  end
end
