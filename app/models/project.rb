class Project < ActiveRecord::Base
  has_and_belongs_to_many :users

  def have_user?(a_user)
    self.users.include?(a_user)
  end

end
