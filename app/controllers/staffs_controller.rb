class StaffsController < ApplicationController
  before_action :authenticate_staff!

  def index
  end

  def staff_email
    render :json => {:staff_email => current_staff.email }
  end

  def staff_logout
    sign_out current_staff
    redirect_to root_path
  end
end
