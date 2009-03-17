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

ActiveRecord::Schema.define(:version => 20090317194303) do

  create_table "advanced_searches", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nickname"
    t.string   "email"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "address_street"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.date     "hired_before"
    t.date     "hired_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender"
  end

  create_table "advanced_searches_certifications", :id => false, :force => true do |t|
    t.integer "advanced_search_id"
    t.integer "certification_id"
  end

  create_table "certifications", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "database_updates", :force => true do |t|
    t.string   "spreadsheet_path"
    t.text     "changes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "update_type"
  end

  create_table "houses", :force => true do |t|
    t.text     "agency_staff"
    t.text     "overview"
    t.text     "ratio"
    t.text     "trainings_needed"
    t.text     "medication_times"
    t.text     "waivers"
    t.text     "keys"
    t.text     "schedule_info"
    t.text     "phone_numbers"
    t.string   "name"
    t.string   "address_street"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.string   "phone_1"
    t.string   "phone_2"
    t.string   "fax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "behavior_plans"
    t.string   "bu_code"
  end

  create_table "houses_individuals", :force => true do |t|
    t.integer "house_id"
    t.integer "individual_id"
  end

  create_table "houses_people", :force => true do |t|
    t.integer "house_id"
    t.integer "person_id"
  end

  create_table "individuals", :force => true do |t|
    t.string   "name"
    t.string   "guardian_name"
    t.string   "guardian_phone_home"
    t.string   "guardian_phone_work"
    t.string   "guardian_phone_mobile"
    t.string   "pcp"
    t.string   "pcp_phone_number"
    t.string   "day_program"
    t.string   "day_program_phone"
    t.string   "transportation"
    t.string   "transportation_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nickname"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "email_address"
    t.string   "gender"
    t.string   "address_street"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.date     "doh"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pay_rate_dollars"
    t.integer  "pay_rate_cents"
    t.integer  "hrid"
    t.integer  "bu_code"
    t.string   "position"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "image"
  end

  create_table "people_roles", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "role_id"
  end

  create_table "persons_certifications", :force => true do |t|
    t.integer  "certification_id"
    t.integer  "person_id"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights", :force => true do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
