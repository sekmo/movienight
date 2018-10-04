# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181003162241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendships", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.datetime "confirmation_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_friendships_on_receiver_id"
    t.index ["sender_id"], name: "index_friendships_on_sender_id"
  end

  create_table "movies", force: :cascade do |t|
    t.integer "tmdb_code"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "poster_path"
    t.integer "length"
    t.json "directors"
    t.decimal "rating", precision: 2, scale: 1
    t.integer "year"
    t.index ["tmdb_code"], name: "index_movies_on_tmdb_code", unique: true
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string "nickname", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "image_data"
    t.index ["nickname"], name: "index_profiles_on_nickname", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishes", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id", "profile_id"], name: "index_wishes_on_movie_id_and_profile_id", unique: true
    t.index ["movie_id"], name: "index_wishes_on_movie_id"
    t.index ["profile_id", "movie_id"], name: "index_wishes_on_profile_id_and_movie_id"
    t.index ["profile_id"], name: "index_wishes_on_profile_id"
  end

  add_foreign_key "friendships", "profiles", column: "receiver_id"
  add_foreign_key "friendships", "profiles", column: "sender_id"
  add_foreign_key "profiles", "users", on_delete: :cascade
  add_foreign_key "wishes", "movies", on_delete: :cascade
  add_foreign_key "wishes", "profiles"
end
