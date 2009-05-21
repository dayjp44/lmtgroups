class PhoneAndEmailOnMember < ActiveRecord::Migration
  def self.up
    add_column :members, :phone, :string
    add_column :members, :email, :string
  end

  def self.down
    remove_column :members, :phone
    remove_column :members, :email
  end
end
