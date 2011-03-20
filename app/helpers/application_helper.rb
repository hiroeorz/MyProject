module ApplicationHelper

  def login_user
    warden.user
  end

end
