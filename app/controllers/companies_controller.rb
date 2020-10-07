class CompaniesController < ApplicationController

  before_action :authenticate_staff!, only: [:index]

  def index
    render :json => Company.all.includes(:juristic_type).pluck_all(:name, '"juristic_types"."name" as jur_type', :inn, :ogrn)
  end
end
