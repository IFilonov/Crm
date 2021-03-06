class CompaniesController < ApplicationController
  before_action :authenticate_staff!
  before_action :find_client, only: [:client_companies]
  before_action :find_company, only: [:update, :clients, :devices, :rebind_refs_data]

  FILTERS = {
    filter_name: lambda { |scope, filter_name| scope.where("lower(companies.name) like ?", "%#{filter_name.downcase}%") }
  }

  def index
    render :json => Company.all.pluck_all(:name, :id)
  end

  def part
    scope = Company.all
    FILTERS.each_pair do |key, filter|
      scope = filter.call(scope, params[key]) if params[key].present?
    end
    sleep 0.5  #for visual effect
    render :json => scope.includes(:juristic_type).order(updated_at: :desc).paginate(page: params[:page], per_page: params[:per_page]).
        pluck_all(:id, :name, :juristic_type_id, '"juristic_types"."name" as jur_type', :inn, :ogrn, :updated_at)
  end

  def count
    render :json => Company.count
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
