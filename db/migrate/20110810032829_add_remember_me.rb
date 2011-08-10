class AddRememberMe < ActiveRecord::Migration
  def self.up
    add_column :accounts, :rememberhash, :text, :limit => 150
  end

  def self.down
    remove_column :accounts, :rememberhash
  end
end
