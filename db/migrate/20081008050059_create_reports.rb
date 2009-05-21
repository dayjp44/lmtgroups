class CreateReports < ActiveRecord::Migration
  def self.up    
    create_table :reports do |t|
      t.column :user_id, :integer
      t.column :notes, :text
      t.column :other_attendees_names, :text
      t.column :other_attendees_number, :integer
      t.column :total_present, :integer
      t.column :offering_amount, :float
      t.column :facilitated_by, :string
      t.column :intern, :string
      t.column :worship_leader, :string
      t.column :meeting_location, :string
      t.column :date_of_meeting, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
