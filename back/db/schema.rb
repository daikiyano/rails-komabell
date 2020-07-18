# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_18_022453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "bookshelves", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "isbn", null: false
    t.string "imageurl"
    t.text "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_bookshelves_on_user_id"
  end

  create_table "skill_categories", force: :cascade do |t|
    t.string "tag_name", null: false
    t.string "icon_url"
    t.integer "followers_count"
    t.integer "items_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_skill_categories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "skill_category_id", null: false
    t.integer "skill"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill"], name: "index_user_skill_categories_on_skill"
    t.index ["skill_category_id"], name: "index_user_skill_categories_on_skill_category_id"
    t.index ["user_id", "skill_category_id"], name: "index_user_skill_categories_on_user_id_and_skill_category_id", unique: true
    t.index ["user_id"], name: "index_user_skill_categories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "login_token"
    t.datetime "login_token_valid_until"
    t.string "username", limit: 25
    t.integer "gender", limit: 2
    t.integer "age", limit: 2
    t.text "description"
    t.string "twitter_id", limit: 40
    t.string "facebook_id", limit: 40
    t.string "wantedly_id", limit: 40
    t.string "github_id", limit: 40
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookshelves", "users"
  add_foreign_key "user_skill_categories", "skill_categories"
  add_foreign_key "user_skill_categories", "users"
end
