class AddStepsClosed < ActiveRecord::Migration
  def self.up
    add_column :steps, :closed, :boolean
  end

  def self.down
    drop_column :steps, :closed
  end
end
