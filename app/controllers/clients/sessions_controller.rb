# frozen_string_literal: true

class Clients::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @user = Client.first
    @link = new_staff_session_path
    @link_name = "Staffs"
    @title_name = "Clients"
    super
    flash.clear
  end

  # POST /resource/sign_in
   def create
     super
     flash.clear
   end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end