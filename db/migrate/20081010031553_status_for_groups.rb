class StatusForGroups < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :string
  end

  def self.down
    remove_column :users, :status, :string
  end
end
