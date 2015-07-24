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

ActiveRecord::Schema.define(version: 20150724015552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "seq"
    t.integer  "categorytype_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["categorytype_id"], name: "index_categories_on_categorytype_id", using: :btree

  create_table "category_recipes", force: :cascade do |t|
    t.string   "keyword"
    t.integer  "category_id"
    t.integer  "recipe_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "category_recipes", ["category_id"], name: "index_category_recipes_on_category_id", using: :btree
  add_index "category_recipes", ["recipe_id"], name: "index_category_recipes_on_recipe_id", using: :btree

  create_table "categorytypes", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issuedescriptions", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "full_title",     limit: 255
    t.integer  "seq"
    t.integer  "publication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issuedescriptions", ["publication_id"], name: "index_issuedescriptions_on_publication_id", using: :btree

  create_table "issuemonths", force: :cascade do |t|
    t.integer  "monthindex"
    t.integer  "issuedescription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issuemonths", ["issuedescription_id"], name: "index_issuemonths_on_issuedescription_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.integer  "issuedescription_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "no"
    t.integer  "year"
  end

  add_index "issues", ["issuedescription_id"], name: "index_issues_on_issuedescription_id", using: :btree

  create_table "publications", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "published",   limit: 255
    t.string   "description", limit: 255
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "page"
    t.string   "url",        limit: 255
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipes", ["issue_id"], name: "index_recipes_on_issue_id", using: :btree

  create_table "user_issues", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_issues", ["issue_id"], name: "index_user_issues_on_issue_id", using: :btree
  add_index "user_issues", ["user_id"], name: "index_user_issues_on_user_id", using: :btree

  create_table "user_recipes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.integer  "rating"
    t.integer  "like",       default: 0
    t.string   "comment"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_recipes", ["recipe_id"], name: "index_user_recipes_on_recipe_id", using: :btree
  add_index "user_recipes", ["user_id"], name: "index_user_recipes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "screen_name",     limit: 255
    t.string   "password_digest", limit: 255
    t.string   "remember_digest", limit: 255
    t.boolean  "admin"
  end

  add_foreign_key "category_recipes", "categories"
  add_foreign_key "category_recipes", "recipes"
  add_foreign_key "user_issues", "issues"
  add_foreign_key "user_issues", "users"
  add_foreign_key "user_recipes", "recipes"
  add_foreign_key "user_recipes", "users"
end
