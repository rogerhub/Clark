class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name, :limit => 60
      t.text :description #contains symbolic replacement tags like [eventstart] that are converted dynamically using database data
            
      t.text :summary
      t.datetime :eventstart
      t.datetime :eventend
      t.datetime :signupstart
      t.datetime :signupend
      t.datetime :activestart
      t.datetime :activeend
      t.boolean :autoaccept, :default => true
      t.integer :pointvalue
      t.string :difficulty, :limit => 20 #HARD, CUSTOM, etc..
      t.text :chairpeople #hash tags
      
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
