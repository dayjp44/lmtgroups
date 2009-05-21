class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.column :controller,             :string
      t.column :action,                 :string
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
