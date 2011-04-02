class AddStepsMyStepUserId < ActiveRecord::Migration
  def self.up
    add_column :steps, :my_step_user_id, :integer
  end

  def self.down
    drop_column :steps, :my_step_user_id
  end
end
