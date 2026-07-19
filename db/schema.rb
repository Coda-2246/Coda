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

ActiveRecord::Schema[8.1].define(version: 2026_07_18_104543) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "entries", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2
    t.decimal "amount_home", precision: 12, scale: 2
    t.integer "category"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "description"
    t.date "entry_date"
    t.decimal "fx_rate", precision: 18, scale: 8
    t.bigint "gig_id"
    t.integer "kind"
    t.jsonb "parsed_data"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["gig_id"], name: "index_entries_on_gig_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string "base_currency"
    t.datetime "created_at", null: false
    t.decimal "rate", precision: 18, scale: 8
    t.date "rate_date"
    t.string "target_currency"
    t.datetime "updated_at", null: false
    t.index ["base_currency", "target_currency", "rate_date"], name: "idx_on_base_currency_target_currency_rate_date_3494ad8994", unique: true
  end

  create_table "gigs", force: :cascade do |t|
    t.string "city"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.decimal "fee_amount", precision: 12, scale: 2
    t.string "fee_currency"
    t.string "name"
    t.date "start_date"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "venue"
    t.index ["user_id"], name: "index_gigs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "home_currency"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "entries", "gigs"
  add_foreign_key "entries", "users"
  add_foreign_key "gigs", "users"
end
