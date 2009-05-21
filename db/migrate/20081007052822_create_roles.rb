class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :rolename,         :string
      t.timestamps
    end
    
    create_table :permissions_roles, :id => false do |t|
      t.column :permission_id,    :integer
      t.column :role_id,          :integer
    end
    
  end

  def self.down
    drop_table :roles
    drop_table :permissions_roles
  end
end
