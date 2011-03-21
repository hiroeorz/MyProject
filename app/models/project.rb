class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :steps

  def have_user?(a_user)
    self.users.include?(a_user)
  end

  alias member? have_user?

  def members
    self.users
  end
end
