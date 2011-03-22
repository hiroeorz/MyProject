class Add < ActiveRecord::Migration
  def self.up
    #add_column :users, :icon_link, :string, :default => ""
  end

  def self.down
    #remove_column :users, :icon_link
  end
end
