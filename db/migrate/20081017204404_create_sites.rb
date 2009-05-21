class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.column :domain, :string
      t.column :admin_contact, :string
      t.column :admin_email, :string
      t.column :admin_phone, :string
      t.timestamps
    end
    
    create_table :meeting_dates do |t|
      t.column :site_id, :integer
      t.column :meeting_date, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
    drop_table :meeting_dates
  end
end
