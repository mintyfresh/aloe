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

ActiveRecord::Schema[7.0].define(version: 2023_08_17_024757) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deck_lists", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.string "deck_name", null: false
    t.string "pony_head_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_deck_lists_on_registration_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "created_by_id", null: false
    t.string "name", null: false
    t.string "format"
    t.string "description"
    t.string "location"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_events_on_created_by_id"
    t.check_constraint "start_date IS NULL OR end_date IS NULL OR start_date <= end_date"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "user_id"], name: "index_registrations_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "discord_id", null: false
    t.string "name", null: false
    t.string "role", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discord_id"], name: "index_users_on_discord_id", unique: true
  end

  add_foreign_key "deck_lists", "registrations"
  add_foreign_key "events", "users", column: "created_by_id"
  add_foreign_key "registrations", "events"
  add_foreign_key "registrations", "users"
end
