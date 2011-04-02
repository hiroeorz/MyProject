class AddUsersUsers < ActiveRecord::Migration
  def self.up
    create_table :users_users, :id => false do |t|
      t.references :user
      t.references :follower
    end
  end

  def self.down
    drop_table :users_users
  end
end
