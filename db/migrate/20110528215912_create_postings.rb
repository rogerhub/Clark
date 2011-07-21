class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.integer :account_id
      t.integer :event_id
      t.text :content
      t.boolean :sticky, :default => false #this will be used for stickies
      t.integer :reply_to
      t.timestamps #creates created_at and updated_at, this should be sufficient
    end
    add_index :postings, :account_id
    add_index :postings, :event_id
    add_index :postings, :reply_to
  end

  def self.down
    drop_table :postings
  end
end
