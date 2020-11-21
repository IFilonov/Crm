class JuristicTypesController < ApplicationController
  before_action :authenticate_staff!, only: [:index]

  def index
    render :json => JuristicType.all.pluck_all(:id, :name)
  end
end
