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

ActiveRecord::Schema[7.1].define(version: 2023_12_18_055944) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "admins", primary_key: "admin_id", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.integer "age"
    t.date "bday"
    t.string "e_address"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "announcement_boards", primary_key: "announcement_board_id", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "anounced_time"
  end

  create_table "schedules", primary_key: "schedule_id", force: :cascade do |t|
    t.string "time_in"
    t.string "time_out"
    t.string "day_of_week"
  end

  create_table "sections", primary_key: "section_id", force: :cascade do |t|
    t.string "section_name"
    t.string "grade_lvl"
    t.string "section_year"
    t.bigint "teacher_id"
    t.index ["teacher_id"], name: "index_sections_on_teacher_id"
  end

  create_table "student_grades", primary_key: "student_grade_id", force: :cascade do |t|
    t.integer "first_grading"
    t.integer "second_grading"
    t.integer "third_grading"
    t.integer "fourth_grading"
    t.bigint "section_id"
    t.bigint "subject_id"
    t.bigint "student_id"
    t.float "average"
    t.string "result"
    t.bigint "teacher_id"
    t.index ["section_id"], name: "index_student_grades_on_section_id"
    t.index ["student_id"], name: "index_student_grades_on_student_id"
    t.index ["subject_id"], name: "index_student_grades_on_subject_id"
    t.index ["teacher_id"], name: "index_student_grades_on_teacher_id"
  end

  create_table "students", primary_key: "student_id", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.integer "age"
    t.date "bday"
    t.string "e_address"
    t.bigint "user_id"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_students_on_section_id"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "subject_teacher_sections", primary_key: "subject_teacher_sections_id", force: :cascade do |t|
    t.bigint "teacher_id"
    t.bigint "section_id"
    t.bigint "subject_id"
    t.bigint "schedule_id"
    t.index ["schedule_id"], name: "index_subject_teacher_sections_on_schedule_id"
    t.index ["section_id"], name: "index_subject_teacher_sections_on_section_id"
    t.index ["subject_id"], name: "index_subject_teacher_sections_on_subject_id"
    t.index ["teacher_id"], name: "index_subject_teacher_sections_on_teacher_id"
  end

  create_table "subjects", primary_key: "subject_id", force: :cascade do |t|
    t.string "subject_name"
  end

  create_table "teachers", primary_key: "teacher_id", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.integer "age"
    t.date "bday"
    t.string "e_address"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_teachers_on_user_id"
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string "email"
    t.string "account_type"
    t.string "password_digest"
  end

  add_foreign_key "admins", "users", primary_key: "user_id"
  add_foreign_key "sections", "teachers", primary_key: "teacher_id"
  add_foreign_key "student_grades", "sections", primary_key: "section_id"
  add_foreign_key "student_grades", "students", primary_key: "student_id"
  add_foreign_key "student_grades", "subjects", primary_key: "subject_id"
  add_foreign_key "student_grades", "teachers", primary_key: "teacher_id"
  add_foreign_key "students", "sections", primary_key: "section_id"
  add_foreign_key "students", "users", primary_key: "user_id"
  add_foreign_key "subject_teacher_sections", "schedules", primary_key: "schedule_id"
  add_foreign_key "subject_teacher_sections", "sections", primary_key: "section_id"
  add_foreign_key "subject_teacher_sections", "subjects", primary_key: "subject_id"
  add_foreign_key "subject_teacher_sections", "teachers", primary_key: "teacher_id"
  add_foreign_key "teachers", "users", primary_key: "user_id"
end
