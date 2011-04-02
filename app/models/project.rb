class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :steps, :conditions => {:closed => nil}, :order => :id

  has_many :avairable_steps, :class_name => "Step",
           :conditions => ["closed is NULL and user_id is not NULL"],
           :order => :id

  has_many :nobody_steps, :class_name => "Step",
           :conditions => ["closed is NULL and 
                            user_id is NULL and 
                            my_step_user_id is NULL"],
           :order => :id

  has_many :chargered_steps, :class_name => "Step",
           :conditions => ["closed is NULL and 
                            user_id is NULL and 
                            my_step_user_id is not NULL"],
           :order => :id

  has_many :histories

  has_and_belongs_to_many :watchers, :class_name => "User", 
                          :join_table => "projects_watchers",
                          :foreign_key => :project_id,
                          :association_foreign_key=> :user_id

  def have_user?(a_user)
    self.users.include?(a_user)
  end

  alias member? have_user?

  def members
    self.users
  end
end
