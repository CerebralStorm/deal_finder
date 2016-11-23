# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161123012952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lead_stages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string   "entry_number"
    t.date     "filing_date"
    t.string   "deceased"
    t.string   "address"
    t.string   "parcel_number"
    t.string   "document_type"
    t.string   "city"
    t.string   "zip"
    t.string   "heir"
    t.string   "contact_info"
    t.integer  "assessed_value"
    t.integer  "zillow_value"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "type"
    t.integer  "lead_stage_id"
    t.boolean  "hidden",         default: false
  end

  create_table "liens", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "lead_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parcel_entries", force: :cascade do |t|
    t.integer  "parcel_id"
    t.string   "number"
    t.string   "book"
    t.string   "page"
    t.string   "instrument_type"
    t.string   "recorded_date"
    t.string   "first_party"
    t.string   "second_party"
    t.string   "consideration"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "parcels", force: :cascade do |t|
    t.string   "number"
    t.string   "address"
    t.string   "owner"
    t.string   "owner_address"
    t.float    "acres"
    t.integer  "land_value"
    t.integer  "building_value"
    t.integer  "total_value"
    t.integer  "lead_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "trust_deeds", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "lead_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
