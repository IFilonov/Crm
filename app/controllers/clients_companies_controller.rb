class ClientsCompaniesController < ApplicationController
  before_action :authenticate_staff!, only: [:client_companies, :company_clients]
  before_action :find_client, only: [:client_companies]
  before_action :find_company, only: [:company_clients]

  def client_companies
    new_companies_params.each do |company|
      @client.clients_companies.create(company_id: company)
    end
    del_companies_params.each do |company|
      @client.clients_companies.find_by(company_id: company).destroy
    end
  end

  def company_clients
    new_clients_params.each do |client|
      @company.clients_companies.create(client_id: client)
    end
    del_clients_params.each do |client|
      @company.clients_companies.find_by(client_id: client).destroy
    end
  end

  private
  def find_client
    @client = Client.find(params[:client_id])
  end

  def find_company
    @company = Company.find(params[:company_id])
  end

  def new_companies_params
    params.permit(new_company_ids: [])[:new_company_ids]
  end

  def del_companies_params
    params.permit(del_company_ids: [])[:del_company_ids]
  end

  def new_clients_params
    params.permit(new_client_ids: [])[:new_client_ids]
  end

  def del_clients_params
    params.permit(del_client_ids: [])[:del_client_ids]
  end
end
