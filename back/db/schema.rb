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

ActiveRecord::Schema.define(version: 2020_05_17_065859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "skill_categories", force: :cascade do |t|
    t.string "tag_name", null: false
    t.string "icon_url"
    t.integer "followers_count"
    t.integer "items_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.string "image", limit: 80
    t.string "twitter_id", limit: 40
    t.string "facebook_id", limit: 40
    t.string "wantedly_id", limit: 40
    t.string "github_id", limit: 40
  end

end
