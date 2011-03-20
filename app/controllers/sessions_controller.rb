class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def signin
    authenticate!
    redirect_to :controller => :streets, :action => :index
  end

  def unauthenticated
    flash[:notice] = warden.message
    redirect_to :action => new
  end

end
