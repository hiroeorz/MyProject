class StreetsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @projects = Project.find(:all, :limit => 10)
    render
  end
end
