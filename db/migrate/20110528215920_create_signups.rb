class CreateSignups < ActiveRecord::Migration
  def self.up
    create_table :signups do |t|
      t.integer :account_id
      t.integer :event_id
      t.string :status, :limit => 20
      t.integer :pointvalue
      t.string :difficulty, :limit => 20 #this theoretically should have no association with the difficulty level stored in Events.
      t.string :semester, :limit => 20 #we need things like "SPRING_2011" stored in a constant
      t.datetime :completiondate      
      t.text :comments
      t.timestamps
    end
    add_index :signups, :account_id
    add_index :signups, :event_id
  end

  def self.down
    drop_table :signups
  end
end