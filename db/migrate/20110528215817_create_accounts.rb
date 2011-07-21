class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :studentid
      t.string :name, :limit => 35
      t.string :password, :limit => 150 #actually, 128 is enough
      t.string :title, :limit => 20
      t.string :privileges, :limit => 15
      t.integer :year
      t.string :email, :limit => 50
      t.string :telephone, :limit => 18 #11 is enough, eg (909) - 123 - 4567
      t.text :contact 
      t.text :schedule
      t.integer :group_id
      t.text :comments
      t.timestamps
    end
    
    add_index :accounts, :group_id
  end

  def self.down
    drop_table :accounts
  end
end
