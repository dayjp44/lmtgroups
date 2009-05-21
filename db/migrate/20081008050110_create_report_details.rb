class CreateReportDetails < ActiveRecord::Migration
  def self.up
    create_table :report_details do |t|
      t.column :report_id, :integer
      t.column :member_id, :integer
      t.column :status, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :report_details
  end
end