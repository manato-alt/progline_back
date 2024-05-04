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

ActiveRecord::Schema.define(version: 2024_04_30_112232) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "image_url"
    t.boolean "is_original", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.string "image_url"
    t.string "favicon_url"
    t.string "url"
    t.integer "user_id", null: false
    t.integer "service_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_id"], name: "index_contents_on_service_id"
    t.index ["user_id"], name: "index_contents_on_user_id"
  end

  create_table "service_registrations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "category_id", null: false
    t.integer "service_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_service_registrations_on_category_id"
    t.index ["service_id"], name: "index_service_registrations_on_service_id"
    t.index ["user_id", "category_id", "service_id"], name: "index_unique_service_registrations_on_user_category_service", unique: true
    t.index ["user_id"], name: "index_service_registrations_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.boolean "is_original", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "term_registrations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_term_registrations_on_category_id"
    t.index ["user_id", "category_id"], name: "index_term_registrations_on_user_id_and_category_id", unique: true
    t.index ["user_id"], name: "index_term_registrations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contents", "services"
  add_foreign_key "contents", "users"
  add_foreign_key "service_registrations", "categories"
  add_foreign_key "service_registrations", "services"
  add_foreign_key "service_registrations", "users"
  add_foreign_key "term_registrations", "categories"
  add_foreign_key "term_registrations", "users"
end
