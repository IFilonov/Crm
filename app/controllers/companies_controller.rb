class CompaniesController < ApplicationController

  before_action :authenticate_staff!, only: [:index, :delete]

  def index
    render :json => Company.all.includes(:juristic_type).pluck_all(:id, :name, '"juristic_types"."name" as jur_type', :inn, :ogrn)
  end

  def delete
    Company.destroy(companies_delete_params)
  end

  private

  def companies_delete_params
    params.permit(ids: [])[:ids]
  end
end
