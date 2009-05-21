class ZipOnMember < ActiveRecord::Migration
  def self.up
    add_column :members, :zip, :string
    add_column :members, :sex, :string
  end

  def self.down
    remove_column :members, :zip
    remove_column :members, :sex
  end
end
