class DevicesController < ApplicationController
  before_action :authenticate_staff!, only: [:create, :index, :delete, :update, :device]
  before_action :find_device, only: [:update, :device]
  
  def index
    render :json => Device.all.pluck_all(:id, :name, :type, :serial)
  end

  def create
    device = Device.new(device_params)
    device.save!
  end

  def delete
    Device.destroy(devices_delete_params)
  end

  def update
    @device.update(device_params)
  end

  def device
    render :json => @device
  end

  private
  def find_device
    @device = Device.find(params[:id])
  end

  def devices_delete_params
    params.permit(ids: [])[:ids]
  end

  def device_params
    params.require(:device).permit(:name, :type, :serial, :company_id)
  end
end
