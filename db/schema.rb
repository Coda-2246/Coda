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

ActiveRecord::Schema[8.1].define(version: 2026_07_30_080922) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.integer "status", default: 0
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
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "venue"
    t.index ["user_id"], name: "index_gigs_on_user_id"
  end

  create_table "tax_adviser_conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_tax_adviser_conversations_on_user_id"
  end

  create_table "tax_adviser_messages", force: :cascade do |t|
    t.text "answer"
    t.datetime "created_at", null: false
    t.text "question"
    t.bigint "tax_adviser_conversation_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["tax_adviser_conversation_id"], name: "index_tax_adviser_messages_on_tax_adviser_conversation_id"
    t.index ["user_id"], name: "index_tax_adviser_messages_on_user_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "entries", "gigs"
  add_foreign_key "entries", "users"
  add_foreign_key "gigs", "users"
  add_foreign_key "tax_adviser_conversations", "users"
  add_foreign_key "tax_adviser_messages", "tax_adviser_conversations"
  add_foreign_key "tax_adviser_messages", "users"
end
