class AddHistoriesProject < ActiveRecord::Migration
  def self.up
    add_column :histories, :project_id, :integer
  end

  def self.down
    drop_column :histories, :project
  end
end
