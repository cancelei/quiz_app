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

ActiveRecord::Schema[8.0].define(version: 2024_10_25_162203) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "content"
    t.boolean "correct"
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "content"
    t.string "image_url"
    t.boolean "multiple_correct_answers"
    t.bigint "quiz_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quiz_accesses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "quiz_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_accesses_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_accesses_on_user_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "time_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_answers", force: :cascade do |t|
    t.bigint "user_quiz_attempt_id", null: false
    t.bigint "question_id", null: false
    t.bigint "answer_id", null: false
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_user_answers_on_answer_id"
    t.index ["question_id"], name: "index_user_answers_on_question_id"
    t.index ["user_quiz_attempt_id"], name: "index_user_answers_on_user_quiz_attempt_id"
  end

  create_table "user_quiz_attempts", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.bigint "user_id", null: false
    t.boolean "completed"
    t.decimal "score"
    t.datetime "attempted_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_user_quiz_attempts_on_quiz_id"
    t.index ["user_id"], name: "index_user_quiz_attempts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quiz_accesses", "quizzes"
  add_foreign_key "quiz_accesses", "users"
  add_foreign_key "quizzes", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_answers", "answers"
  add_foreign_key "user_answers", "questions"
  add_foreign_key "user_answers", "user_quiz_attempts"
  add_foreign_key "user_quiz_attempts", "quizzes"
  add_foreign_key "user_quiz_attempts", "users"
end
