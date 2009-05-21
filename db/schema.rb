# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090505031738) do

  create_table "facilitator_assignments", :force => true do |t|
    t.integer  "coach_id",       :default => 0, :null => false
    t.integer  "facilitator_id", :default => 0, :null => false
    t.integer  "position",       :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grading_assignments", :force => true do |t|
    t.integer  "grading_component_id"
    t.integer  "grading_id"
    t.integer  "value"
    t.string   "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grading_components", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gradings", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meeting_dates", :force => true do |t|
    t.integer  "site_id"
    t.datetime "meeting_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status",     :default => ""
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "inactive",   :default => false
    t.string   "zip"
    t.string   "sex"
    t.string   "phone"
    t.string   "email"
    t.boolean  "contacted",  :default => false
    t.text     "notes"
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  create_table "report_details", :force => true do |t|
    t.integer  "report_id"
    t.integer  "member_id"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.text     "notes"
    t.text     "other_attendees_names"
    t.integer  "other_attendees_number"
    t.integer  "total_present"
    t.float    "offering_amount"
    t.string   "facilitated_by"
    t.string   "intern"
    t.string   "worship_leader"
    t.string   "meeting_location"
    t.datetime "date_of_meeting"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "domain"
    t.string   "admin_contact"
    t.string   "admin_email"
    t.string   "admin_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.integer  "role_id"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "status"
    t.string   "lat"
    t.string   "lng"
    t.string   "country",                                 :default => "United States"
  end

end
