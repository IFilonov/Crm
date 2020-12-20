class JuristicTypesController < ApplicationController
  def index
    render :json => JuristicType.all.pluck_all(:id, :name)
  end
end
