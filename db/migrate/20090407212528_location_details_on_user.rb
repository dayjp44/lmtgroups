class LocationDetailsOnUser < ActiveRecord::Migration
  def self.up
    add_column :users, :lat, :string
    add_column :users, :lng, :string
    add_column :users, :country, :string, :default => "United States"
  end

  def self.down
    remove_column :users, :lat
    remove_column :users, :lng
    remove_column :users, :country
  end
end
