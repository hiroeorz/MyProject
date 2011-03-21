class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :validatable, :confirmable, :lockable

  has_and_belongs_to_many :projects
  has_one :step
  has_one :created_step, :class_name => "Step", :foreign_key => :created_user_id

  def have_project?(a_project)
    self.projects.include?(a_project)
  end

end
