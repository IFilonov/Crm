class ApplicationController < ActionController::Base
  before_action :authenticate_staff! || :authenticate_client!

  def index; end
end
