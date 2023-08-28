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

ActiveRecord::Schema[7.0].define(version: 2023_08_26_142452) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.binary "token", null: false
    t.string "name", null: false
    t.bigint "requests_count", default: 0, null: false
    t.datetime "last_request_at", precision: nil
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "digest(token, 'sha256'::text)", name: "index_api_keys_on_token_digest", using: :hash
    t.index ["token"], name: "index_api_keys_on_token", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "deck_lists", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.string "deck_name", null: false
    t.string "pony_head_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_deck_lists_on_registration_id", unique: true
  end

  create_table "discord_guilds", force: :cascade do |t|
    t.bigint "guild_id", null: false
    t.bigint "installed_by_id", null: false
    t.bigint "event_channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guild_id"], name: "index_discord_guilds_on_guild_id", unique: true
    t.index ["installed_by_id"], name: "index_discord_guilds_on_installed_by_id"
  end

  create_table "discord_messages", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "channel_id", null: false
    t.bigint "guild_id", null: false
    t.string "content"
    t.datetime "posted_at", precision: nil
    t.datetime "edited_at", precision: nil
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "deleted_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_discord_messages_on_message_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "guild_id", null: false
    t.bigint "created_by_id", null: false
    t.citext "name", null: false
    t.string "slug", null: false
    t.string "format"
    t.string "description"
    t.string "location"
    t.date "starts_on"
    t.date "ends_on"
    t.boolean "enforce_guild_membership", default: true, null: false
    t.integer "registrations_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_events_on_created_by_id"
    t.index ["guild_id"], name: "index_events_on_guild_id"
    t.index ["name"], name: "index_events_on_name", unique: true
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.check_constraint "starts_on IS NULL OR ends_on IS NULL OR starts_on <= ends_on"
  end

  create_table "message_links", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.string "linkable_type", null: false
    t.bigint "linkable_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linkable_type", "linkable_id", "name"], name: "index_message_links_on_linkable_and_name", unique: true
    t.index ["linkable_type", "linkable_id"], name: "index_message_links_on_linkable"
    t.index ["message_id"], name: "index_message_links_on_message_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.boolean "dropped", default: false, null: false
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

  add_foreign_key "api_keys", "users"
  add_foreign_key "deck_lists", "registrations"
  add_foreign_key "events", "discord_guilds", column: "guild_id"
  add_foreign_key "events", "users", column: "created_by_id"
  add_foreign_key "message_links", "discord_messages", column: "message_id"
  add_foreign_key "registrations", "events"
  add_foreign_key "registrations", "users"
end
