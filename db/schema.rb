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

ActiveRecord::Schema.define(version: 2018_09_26_152925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availability_logs", force: :cascade do |t|
    t.string "status"
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "log_type"
  end

  create_table "code_cares", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.string "advisory_id"
    t.date "startdate"
    t.date "enddate"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_code_cares_on_project_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "gemfiles", force: :cascade do |t|
    t.string "gemfile"
    t.string "commit"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["project_id"], name: "index_gemfiles_on_project_id"
  end

  create_table "incident_logs", force: :cascade do |t|
    t.string "metric_value"
    t.string "project_name"
    t.datetime "timestamp"
    t.string "graylog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "incident_id"
    t.index ["incident_id"], name: "index_incident_logs_on_incident_id"
  end

  create_table "incidents", force: :cascade do |t|
    t.datetime "time_from"
    t.datetime "time_to"
    t.text "what_happened"
    t.string "which_server"
    t.text "realized_error"
    t.text "solution"
    t.text "impacts"
    t.text "future_approach"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_incidents_on_project_id"
  end

  create_table "performances", force: :cascade do |t|
    t.integer "requests"
    t.integer "response_time"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.float "error_rate"
    t.bigint "clean_errors"
    t.index ["project_id"], name: "index_performances_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.string "repo_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer"
    t.boolean "archived", default: false
    t.string "appsignal_id"
    t.string "slug"
  end

  create_table "reports", force: :cascade do |t|
    t.binary "file"
    t.datetime "created_on"
    t.date "month"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "is_sent"
    t.index ["project_id"], name: "index_reports_on_project_id"
  end

  create_table "sentry_error_logs", force: :cascade do |t|
    t.integer "timestamp"
    t.string "repo_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "events"
    t.bigint "sentry_errors_id"
    t.index ["sentry_errors_id"], name: "index_sentry_error_logs_on_sentry_errors_id"
  end

  create_table "sentry_errors", force: :cascade do |t|
    t.date "day"
    t.integer "number_of_events"
    t.string "repo_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.index ["project_id"], name: "index_sentry_errors_on_project_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.datetime "date"
    t.binary "file"
    t.string "file_type"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_uploads_on_project_id"
  end

  add_foreign_key "code_cares", "projects"
  add_foreign_key "gemfiles", "projects"
  add_foreign_key "incident_logs", "incidents"
  add_foreign_key "incidents", "projects"
  add_foreign_key "performances", "projects"
  add_foreign_key "reports", "projects"
  add_foreign_key "sentry_error_logs", "sentry_errors", column: "sentry_errors_id"
  add_foreign_key "sentry_errors", "projects"
  add_foreign_key "uploads", "projects"
end
