class StaffsController < ApplicationController
  before_action :authenticate_staff!

  def index
  end

  def email
    render :json => {:staff_email => current_staff.email }
  end

  def logout
    sign_out current_staff
    redirect_to new_staff_session_path
  end
end
