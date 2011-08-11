class AddResetHash < ActiveRecord::Migration
  def self.up
    add_column :accounts, :resethash, :text, :limit => 150
  end

  def self.down
    remove_column :accounts, :resethash
  end
end
