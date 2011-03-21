class AddStepsProject < ActiveRecord::Migration
  def self.up
    add_column :steps, :project_id, :integer
  end

  def self.down
    remove_column :steps, :project
  end
end
