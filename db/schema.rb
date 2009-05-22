# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090517163927) do

  create_table "disciplines", :force => true do |t|
    t.string "name"
    t.string "long_name"
  end

  create_table "disciplines_projects", :id => false, :force => true do |t|
    t.integer "discipline_id"
    t.integer "project_id"
  end

  add_index "disciplines_projects", ["discipline_id"], :name => "index_disciplines_projects_on_discipline_id"
  add_index "disciplines_projects", ["project_id"], :name => "index_disciplines_projects_on_project_id"

  create_table "projects", :force => true do |t|
    t.integer  "created_by"
    t.string   "title"
    t.text     "description"
    t.text     "resources"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "carbon_critical", :default => false
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "title",                     :limit => 10
    t.string   "first_name",                :limit => 100
    t.string   "initials",                  :limit => 10
    t.string   "last_name",                 :limit => 100
    t.string   "known_as",                  :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
