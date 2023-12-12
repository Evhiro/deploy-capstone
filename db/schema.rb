# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_10_154834) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "logins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "account_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string "day_of_week"
    t.time "start_time"
    t.time "end_time"
    t.string "subject"
    t.string "section_name"
  end

  create_table "section_students", force: :cascade do |t|
    t.string "name"
    t.string "section_name"
  end

  create_table "sections", force: :cascade do |t|
    t.string "section_name"
    t.string "grade_lvl"
    t.string "advisor"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["section_name"], name: "index_sections_on_section_name", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.string "email"
    t.string "e_address"
    t.string "fname"
    t.string "lname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birth"
  end

  create_table "subject_teachers", force: :cascade do |t|
    t.string "name"
    t.string "subject"
    t.string "section_name"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "subject_name"
    t.string "section_name"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "email"
    t.string "e_address"
    t.string "fname"
    t.string "lname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birth"
  end

  add_foreign_key "schedules", "sections", column: "section_name", primary_key: "section_name"
  add_foreign_key "section_students", "sections", column: "section_name", primary_key: "section_name"
  add_foreign_key "subject_teachers", "sections", column: "section_name", primary_key: "section_name"
  add_foreign_key "subjects", "sections", column: "section_name", primary_key: "section_name"
end
