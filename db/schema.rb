ActiveRecord::Schema.define(version: 2019_08_23_110758) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tag_tasks", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_tag_tasks_on_tag_id"
    t.index ["task_id"], name: "index_tag_tasks_on_task_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "description"
    t.integer "status", default: 0
    t.date "started_at"
    t.date "deadline_at"
    t.integer "emergency_level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_tasks_on_created_at"
    t.index ["deadline_at"], name: "index_tasks_on_deadline_at"
    t.index ["description"], name: "index_tasks_on_description"
    t.index ["status"], name: "index_tasks_on_status"
    t.index ["title"], name: "index_tasks_on_title"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tasks_count", default: 0
  end

  add_foreign_key "tag_tasks", "tags"
  add_foreign_key "tag_tasks", "tasks"
  add_foreign_key "tasks", "users"
end
