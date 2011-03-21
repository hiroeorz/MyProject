class CreateSteps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|
      t.string :name
      t.references :user
      t.references :created_user
    end
  end

  def self.down
    drop_table :steps
  end
end
