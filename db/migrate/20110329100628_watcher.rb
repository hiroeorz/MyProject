class Watcher < ActiveRecord::Migration
  def self.up
    create_table :projects_watchers, :id => false do |t|
      t.references :user
      t.references :project
    end
  end

  def self.down
    drop_table :watchers
  end
end
