class CompaniesController < ApplicationController

  before_action :authenticate_staff!, only: [:index, :delete, :create]

  def index
    render :json => Company.all.includes(:juristic_type).pluck_all(:id, :name, '"juristic_types"."name" as jur_type', :inn, :ogrn)
  end

  def delete
    Company.destroy(companies_delete_params)
  end

  def create
    company = Company.new(company_params)
    company.save!
  end

  private
  def company_params
    params.require(:company).permit(:name, :inn, :ogrn, :juristic_type_id)
  end

  def companies_delete_params
    params.permit(ids: [])[:ids]
  end
end
