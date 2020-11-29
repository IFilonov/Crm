class CompaniesController < ApplicationController
  before_action :authenticate_staff!
  before_action :find_client, only: [:client_companies]
  before_action :find_company, only: [:update, :clients, :devices, :rebind_refs_data]

  def index
    render :json => Company.all.includes(:juristic_type).order(updated_at: :desc).
        pluck_all(:id, :name, :juristic_type_id, '"juristic_types"."name" as jur_type', :inn, :ogrn, :updated_at)
  end

  def delete
    Company.destroy(companies_delete_params)
  end

  def create
    company = Company.new(company_params)
    company.save!
  end

  def client_companies
    render :json => @client.companies.pluck(:id)
  end

  def update
    @company.update(company_params)
  end

  def clients
    render :json => @company.clients.pluck(:id)
  end

  def devices
    render :json => @company.devices.pluck(:id)
  end

  def rebind_refs_data
    new_clients_params.each do |client|
      @company.clients_companies.create(client_id: client)
    end
    del_clients_params.each do |client|
      @company.clients_companies.find_by(client_id: client).destroy
    end
    new_devices_params.each do |id|
      device = Device.lock(true).find(id)
      device.company = @company
      device.save!
    end
    del_devices_params.each do |id|
      device = Device.lock(true).find(id)
      device.company = Company.first
      device.save!
    end
  end

  private
  def company_params
    params.require(:company).permit(:id, :name, :inn, :ogrn, :juristic_type_id)
  end

  def companies_delete_params
    params.permit(ids: [])[:ids]
  end

  def find_client
    @client = Client.find(params[:id])
  end

  def find_company
    @company= Company.find(params[:id])
  end

  def new_clients_params
    params.permit(new_client_ids: [])[:new_client_ids]
  end

  def del_clients_params
    params.permit(del_client_ids: [])[:del_client_ids]
  end

  def new_devices_params
    params.permit(new_device_ids: [])[:new_device_ids]
  end

  def del_devices_params
    params.permit(del_device_ids: [])[:del_device_ids]
  end
end
