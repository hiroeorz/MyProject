module ApplicationHelper

  def login_user
    warden.user
  end

  def user_icon_tag(a_user, args = {})
    new_args = args.merge(:alt => a_user.username, :title => a_user.username)
    link_to( (image_tag a_user.icon_link, new_args),
             {:controller => :users, :action => :show, :id => a_user.id} )
  end

end
