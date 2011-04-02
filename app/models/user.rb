class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :validatable, :confirmable, :lockable

  has_and_belongs_to_many :projects
  has_one :step
  has_many :my_steps, :class_name => "Step", :foreign_key => :my_step_user_id
  has_many :histories
  has_one :created_step, :class_name => "Step", :foreign_key => :created_user_id

  has_and_belongs_to_many :watch_projects, :class_name => "Project", 
                          :join_table => "projects_watchers",
                          :foreign_key=> :user_id,
                          :association_foreign_key => :project_id

  has_and_belongs_to_many :followers, :class_name => "User", 
                          :join_table => "users_users",
                          :foreign_key=> :user_id,
                          :association_foreign_key => :follower_id

  has_and_belongs_to_many :friends, :class_name => "User", 
                          :join_table => "users_users",
                          :foreign_key => :follower_id,
                          :association_foreign_key=> :user_id


  def have_project?(a_project)
    self.projects.include?(a_project)
  end

end
