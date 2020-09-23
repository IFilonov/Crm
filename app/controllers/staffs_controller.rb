class StaffsController < ApplicationController

  before_action :authenticate_staff!

  def staff_email
    render :json => {:staff_email => current_staff.email }
  end

  def staff_logout
    redirect_to destroy_staff_session_path
  end
end
