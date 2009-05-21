class CreateFacilitatorAssignments < ActiveRecord::Migration
  def self.up
    create_table :facilitator_assignments do |t|
      t.column :coach_id, :integer, :null => false, :default => 0
      t.column :facilitator_id, :integer, :null => false, :default => 0
      t.column :position, :integer, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :facilitator_assignments
  end
end
