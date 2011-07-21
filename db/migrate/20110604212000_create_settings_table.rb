class CreateSettingsTable < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name, :limit => 40
      t.text :value
      t.timestamps
    end
    add_index :settings, :name
  end

  def self.down
    drop_table :settings
  end
end
