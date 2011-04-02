class AddProjectsDetail < ActiveRecord::Migration
  def self.up
    add_column :projects, :detail, :text
  end

  def self.down
    drop_column :projects, :detail
  end
end
