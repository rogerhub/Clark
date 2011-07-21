class AddDonationColumn < ActiveRecord::Migration
  def self.up
    add_column :events, :donation, :boolean
  end

  def self.down
    remove_column :events, :donation
  end
end
