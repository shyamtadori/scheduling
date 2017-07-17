# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170718160828) do

  create_table "calendar_hitch_dates", primary_key: "cal_date_hitch_id", force: :cascade do |t|
    t.datetime "work_date"
    t.integer  "cal_hitch_id", precision: 38
  end

  add_index "calendar_hitch_dates", ["cal_hitch_id"], name: "i_cal_hit_dat_cal_hit_id"

  create_table "calendars", primary_key: "calendar_id", force: :cascade do |t|
    t.string   "name"
    t.datetime "effective_start_date"
    t.datetime "effective_end_date"
    t.integer  "created_by",           precision: 38
    t.integer  "last_updated_by",      precision: 38
    t.datetime "creation_date"
    t.datetime "last_update_date"
  end

  create_table "calendars_hitches", primary_key: "cal_hitch_id", force: :cascade do |t|
    t.integer  "calendar_id",                precision: 38
    t.integer  "hitch_id",                   precision: 38
    t.integer  "initial_days_on",  limit: 2, precision: 2
    t.integer  "initial_days_off", limit: 2, precision: 2
    t.integer  "created_by",                 precision: 38
    t.integer  "last_updated_by",            precision: 38
    t.datetime "creation_date"
    t.datetime "last_update_date"
  end

  add_index "calendars_hitches", ["calendar_id", "hitch_id"], name: "i_cal_hit_cal_id_hit_id"
  add_index "calendars_hitches", ["hitch_id"], name: "i_calendars_hitches_hitch_id"

  create_table "calendars_holidays", primary_key: "cal_holiday_id", force: :cascade do |t|
    t.integer  "calendar_id",      precision: 38
    t.integer  "holiday_id",       precision: 38
    t.integer  "created_by",       precision: 38
    t.integer  "last_updated_by",  precision: 38
    t.datetime "creation_date"
    t.datetime "last_update_date"
  end

  create_table "hitches", primary_key: "hitch_id", force: :cascade do |t|
    t.string   "name"
    t.integer  "days_on",          limit: 2,   precision: 2
    t.integer  "days_off",         limit: 2,   precision: 2
    t.boolean  "mon",              limit: nil
    t.boolean  "tue",              limit: nil
    t.boolean  "wed",              limit: nil
    t.boolean  "thu",              limit: nil
    t.boolean  "fri",              limit: nil
    t.boolean  "sat",              limit: nil
    t.boolean  "sun",              limit: nil
    t.datetime "hour_start"
    t.datetime "hour_end"
    t.integer  "created_by",                   precision: 38
    t.integer  "last_updated_by",              precision: 38
    t.datetime "creation_date"
    t.datetime "last_update_date"
  end

  create_table "holidays", primary_key: "holiday_id", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "holiday_date"
    t.integer  "created_by",       precision: 38
    t.datetime "creation_date"
    t.integer  "last_updated_by",  precision: 38
    t.datetime "last_update_date"
  end

  create_table "mission_type_rules", primary_key: "mission_type_rule_id", force: :cascade do |t|
    t.integer  "mission_type_id",      precision: 38
    t.integer  "rule_id",              precision: 38
    t.datetime "effective_start_date"
    t.datetime "effective_end_date"
    t.integer  "created_by",           precision: 38
    t.integer  "last_updated_by",      precision: 38
    t.datetime "creation_date"
    t.datetime "last_update_date"
  end

  add_index "mission_type_rules", ["mission_type_id", "rule_id"], name: "ieb3f3cb6f47ad371c8eccf80cc372"
  add_index "mission_type_rules", ["rule_id"], name: "i_mission_type_rules_rule_id"

  create_table "mission_types", primary_key: "mission_type_id", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "effective_start_date"
    t.datetime "effective_end_date"
    t.integer  "created_by",           precision: 38
    t.integer  "last_updated_by",      precision: 38
    t.datetime "creation_date"
    t.datetime "last_update_date"
  end

  create_table "pilots_hitches", primary_key: "pilots_hitch_id", force: :cascade do |t|
    t.integer  "hitch_id",             precision: 38
    t.datetime "effective_start_date"
    t.datetime "effective_end_date"
    t.integer  "created_by",           precision: 38
    t.integer  "last_updated_by",      precision: 38
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.integer  "user_id",              precision: 38
  end

  add_index "pilots_hitches", ["hitch_id"], name: "i_pilots_hitches_hitch_id"
  add_index "pilots_hitches", ["user_id", "hitch_id"], name: "i_pil_hit_use_id_hit_id"

  create_table "rules", primary_key: "rule_id", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "code_block"
    t.datetime "effective_start_date"
    t.datetime "effective_end_date"
    t.integer  "created_by",           precision: 38
    t.integer  "last_updated_by",      precision: 38
    t.datetime "creation_date"
    t.datetime "last_update_date"
  end

  add_synonym "sg_customers", "seagan.sg_customers@seagan", force: true

end
