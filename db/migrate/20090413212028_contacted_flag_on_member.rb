class ContactedFlagOnMember < ActiveRecord::Migration
  def self.up
    add_column :members, :contacted, :boolean, :default => false
  end

  def self.down
    remove_column :members, :contacted
  end
end
