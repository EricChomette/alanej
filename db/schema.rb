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

ActiveRecord::Schema.define(version: 2021_11_29_125135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conditions", force: :cascade do |t|
    t.string "snow"
    t.string "weather"
    t.bigint "station_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "date"
    t.integer "rain_prob"
    t.integer "fog_prob"
    t.integer "frost_prob"
    t.index ["station_id"], name: "index_conditions_on_station_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "visitor_pseudo"
    t.integer "rating"
    t.bigint "station_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["station_id"], name: "index_reviews_on_station_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.text "description"
    t.string "budget"
    t.integer "alt_min"
    t.integer "alt_max"
    t.integer "total_slopes"
    t.integer "open_slopes"
    t.integer "green_slopes"
    t.integer "green_open_slopes"
    t.integer "blue_slopes"
    t.integer "blue_open_slopes"
    t.integer "red_slopes"
    t.integer "red_open_slopes"
    t.integer "black_slopes"
    t.integer "black_open_slopes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "bannerphoto"
    t.string "cardphoto"
    t.string "insee"
    t.string "logo"
    t.string "lat"
    t.string "long"
    t.string "snowurl"
  end

  add_foreign_key "conditions", "stations"
  add_foreign_key "reviews", "stations"
end
