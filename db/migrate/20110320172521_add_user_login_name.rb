class AddUserLoginName < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, :null => false, :default => ""
    add_column :users, :num_msgs, :integer, :default => 0
    add_column :users, :num_replies, :integer, :default => 0
  end

  def self.down
    remove_column :users, :username
    remove_column :users, :num_msgs
    remove_column :users, :num_replies
  end
end
