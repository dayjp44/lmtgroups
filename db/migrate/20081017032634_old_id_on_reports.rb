class OldIdOnReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :old_id, :integer
  end

  def self.down
    remove_column :reports, :old_id
  end
end
