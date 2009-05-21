class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :status, :string, :default => ""
      t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
