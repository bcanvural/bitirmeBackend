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

ActiveRecord::Schema.define(version: 20150223110347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendance", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "instructor_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "lecture_session", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.string   "qrcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lecture_session", ["course_id"], name: "index_lecture_session_on_course_id", using: :btree
  add_index "lecture_session", ["user_id"], name: "index_lecture_session_on_user_id", using: :btree

  create_table "photos", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "image_url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "random_id"
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
    t.boolean  "instructor"
    t.boolean  "student"
    t.string   "udid"
  end

end
