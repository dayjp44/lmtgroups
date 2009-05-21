class InactiveOnMember < ActiveRecord::Migration
  def self.up
    add_column :members, :inactive, :boolean, :default => 0
  end

  def self.down
    remove_column :members, :inactive
  end
end
