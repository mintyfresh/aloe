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

ActiveRecord::Schema[7.0].define(version: 2023_09_02_044257) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "organization_role", ["admin", "member"]

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

  create_table "discord_record_links", force: :cascade do |t|
    t.string "linkable_type", null: false
    t.bigint "linkable_id", null: false
    t.bigint "record_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linkable_type", "linkable_id", "name"], name: "index_discord_record_links_on_linkable_and_name", unique: true
    t.index ["linkable_type", "linkable_id"], name: "index_discord_record_links_on_linkable"
  end

  create_table "event_check_in_configs", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.integer "start_offset_hours", null: false
    t.integer "duration_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_check_in_configs_on_event_id", unique: true
    t.check_constraint "duration_hours IS NULL OR duration_hours > 0"
    t.check_constraint "start_offset_hours > 0"
  end

  create_table "event_price_configs", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "currency", null: false
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_price_configs_on_event_id", unique: true
    t.check_constraint "amount_cents > 0"
  end

  create_table "event_role_configs", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "name", null: false
    t.string "permissions", default: "0", null: false
    t.integer "colour"
    t.boolean "hoist", default: false, null: false
    t.boolean "mentionable", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_role_configs_on_event_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "created_by_id", null: false
    t.citext "name", null: false
    t.string "slug", null: false
    t.string "format"
    t.string "description"
    t.string "location"
    t.string "time_zone", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "registration_opens_at"
    t.datetime "registration_closes_at"
    t.boolean "enforce_guild_membership", default: true, null: false
    t.integer "registrations_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_events_on_created_by_id"
    t.index ["organization_id", "name"], name: "index_events_on_organization_id_and_name", unique: true
    t.index ["organization_id", "slug"], name: "index_events_on_organization_id_and_slug", unique: true
    t.index ["organization_id"], name: "index_events_on_organization_id"
    t.check_constraint "registration_opens_at IS NULL OR registration_closes_at IS NULL OR registration_opens_at <= registration_closes_at"
    t.check_constraint "starts_at <= ends_at"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "user_id"], name: "index_organization_memberships_on_organization_id_and_user_id", unique: true
    t.index ["organization_id"], name: "index_organization_memberships_on_organization_id"
    t.index ["user_id"], name: "index_organization_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.citext "slug", null: false
    t.binary "install_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "digest(install_token, 'sha256'::text)", name: "index_organizations_on_install_token_digest", using: :hash
    t.index ["install_token"], name: "index_organizations_on_install_token", unique: true
    t.index ["name"], name: "index_organizations_on_name", unique: true
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
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
  add_foreign_key "event_check_in_configs", "events"
  add_foreign_key "event_price_configs", "events"
  add_foreign_key "event_role_configs", "events"
  add_foreign_key "events", "organizations"
  add_foreign_key "events", "users", column: "created_by_id"
  add_foreign_key "organization_memberships", "organizations"
  add_foreign_key "organization_memberships", "users"
  add_foreign_key "registrations", "events"
  add_foreign_key "registrations", "users"
end
