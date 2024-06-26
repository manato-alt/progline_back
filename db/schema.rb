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

ActiveRecord::Schema.define(version: 2024_05_14_092352) do

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "original_url"
    t.string "image"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "title", null: false
    t.string "original_url"
    t.string "favicon_url"
    t.string "url"
    t.string "image"
    t.integer "service_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_id"], name: "index_contents_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "original_url"
    t.string "image"
    t.integer "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_services_on_category_id"
  end

  create_table "shared_codes", force: :cascade do |t|
    t.string "public_name", null: false
    t.string "code"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_shared_codes_on_user_id", unique: true
  end

  create_table "template_categories", force: :cascade do |t|
    t.string "name"
    t.string "original_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "template_services", force: :cascade do |t|
    t.string "name"
    t.string "original_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "categories", "users"
  add_foreign_key "contents", "services"
  add_foreign_key "services", "categories"
  add_foreign_key "shared_codes", "users"
end
