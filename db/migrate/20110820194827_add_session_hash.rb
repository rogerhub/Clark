class AddSessionHash < ActiveRecord::Migration
  def self.up
    add_column :accounts, :sessionhash, :text, :limit => 150
  end

  def self.down
    remove_column :accounts, :sessionhash
  end
end
