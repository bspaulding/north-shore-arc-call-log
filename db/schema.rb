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

ActiveRecord::Schema.define(:version => 20081027160128) do

  create_table "certifications", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "type"
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
    t.datetime "doh"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pay_rate_dollars"
    t.integer  "pay_rate_cents"
  end

  create_table "persons_certifications", :force => true do |t|
    t.integer  "certification_id"
    t.integer  "person_id"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end