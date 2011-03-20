class ApplicationController < ActionController::Base
  protect_from_forgery

  def login_user
    warden.user
  end

end
