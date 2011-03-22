module ApplicationHelper

  def login_user
    warden.user
  end

  def user_icon_tag(a_user, args = {})
    default_args = {
      :alt => a_user.username, 
      :title => a_user.username,
      :width => 45,
      :height => 45
    }

    new_args = default_args.merge(args)
    link_to( (image_tag a_user.icon_link, new_args),
             {:controller => :users, :action => :show, :id => a_user.id} )
  end

end
