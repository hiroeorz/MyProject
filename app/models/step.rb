class Step < ActiveRecord::Base
  belongs_to :user
  belongs_to :created_user, :class_name => "User"
  belongs_to :project
end
