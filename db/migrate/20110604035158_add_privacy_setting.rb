class AddPrivacySetting < ActiveRecord::Migration
  def self.up
    add_column :accounts, :privacy, :integer
  end

  def self.down
    remove_column :accounts, :privacy
  end
end