# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150411150225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendance_lists", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendance_lists", ["course_entity_id"], name: "index_attendance_lists_on_course_entity_id", using: :btree
  add_index "attendance_lists", ["user_id"], name: "index_attendance_lists_on_user_id", using: :btree

  create_table "constants", force: true do |t|
    t.date     "termstartdate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_entities", force: true do |t|
    t.string   "day"
    t.integer  "course_id"
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_entities", ["course_id"], name: "index_course_entities_on_course_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_courses", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "email_verification", default: false
    t.string   "verification_code"
    t.string   "api_authtoken"
    t.datetime "authtoken_expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "instructor",         default: false
    t.boolean  "student",            default: true
    t.string   "udid"
  end

end
