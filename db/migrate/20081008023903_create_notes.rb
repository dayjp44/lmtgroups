class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :user_id, :integer
      t.column :notes, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
