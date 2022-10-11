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

ActiveRecord::Schema[7.0].define(version: 2022_10_10_142920) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "requests", force: :cascade do |t|
    t.date "date"
    t.boolean "approval_status"
    t.integer "space_id"
    t.integer "user_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "space_name"
    t.text "description"
    t.money "price_per_night", scale: 2
    t.integer "user_id"
    t.integer "request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "email"
    t.string "mobile_number"
    t.string "password_digest"
    t.integer "request_id"
  end

end
