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

ActiveRecord::Schema[7.0].define(version: 2022_06_09_110424) do
  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.integer "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["article_id"], name: "index_comments_on_article_id"
  end

  create_table "greed_rolls", force: :cascade do |t|
    t.integer "session_id", null: false
    t.integer "player"
    t.integer "number"
    t.integer "dice_1"
    t.integer "dice_2"
    t.integer "dice_3"
    t.integer "dice_4"
    t.integer "dice_5"
    t.boolean "dice_1_kept"
    t.boolean "dice_2_kept"
    t.boolean "dice_3_kept"
    t.boolean "dice_4_kept"
    t.boolean "dice_5_kept"
    t.index ["session_id"], name: "index_greed_rolls_on_session_id"
  end

  create_table "greed_sessions", force: :cascade do |t|
    t.integer "players"
    t.integer "turn", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "articles"
  add_foreign_key "greed_rolls", "greed_sessions", column: "session_id"
end
