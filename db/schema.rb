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

ActiveRecord::Schema.define(version: 20150414081441) do

  create_table "issuedescriptions", force: true do |t|
    t.string   "title"
    t.string   "full_title"
    t.integer  "seq"
    t.integer  "publication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issuedescriptions", ["publication_id"], name: "index_issuedescriptions_on_publication_id"

  create_table "issuemonths", force: true do |t|
    t.integer  "monthindex"
    t.integer  "issuedescription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issuemonths", ["issuedescription_id"], name: "index_issuemonths_on_issuedescription_id"

  create_table "issues", force: true do |t|
    t.string   "title"
    t.integer  "issuedescription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "no"
    t.integer  "year"
  end

  add_index "issues", ["issuedescription_id"], name: "index_issues_on_issuedescription_id"

  create_table "meals", force: true do |t|
    t.string   "description"
    t.integer  "seq"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publications", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "published"
    t.string   "description"
  end

  create_table "recipes", force: true do |t|
    t.string   "title"
    t.integer  "page"
    t.string   "url"
    t.integer  "issue_id"
    t.integer  "meal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipes", ["issue_id"], name: "index_recipes_on_issue_id"
  add_index "recipes", ["meal_id"], name: "index_recipes_on_meal_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "screen_name"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin"
  end

end
