class AddSynopsis < ActiveRecord::Migration
  def self.up
    add_column :events, :synopsis, :text
  end

  def self.down
    remove_column :events, :synopsis
  end
end
