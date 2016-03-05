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

ActiveRecord::Schema.define(version: 20140310235001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  create_table "availabilities_employees_roles", id: false, force: true do |t|
    t.integer "availability_id",   null: false
    t.integer "employees_role_id", null: false
  end

  add_index "availabilities_employees_roles", ["availability_id", "employees_role_id"], name: "index_on_availability_id_and_employees_role_id", using: :btree
  add_index "availabilities_employees_roles", ["employees_role_id", "availability_id"], name: "index_on_employees_role_id_and_availability_id", using: :btree

  create_table "availabilities_facilities", force: true do |t|
    t.integer "availability_id"
    t.integer "facility_id"
  end

  create_table "availability_day_of_week_availability", id: false, force: true do |t|
    t.integer "availability_id",             null: false
    t.integer "day_of_week_availability_id", null: false
  end

  add_index "availability_day_of_week_availability", ["availability_id"], name: "index_availability_day_of_week_availability_on_availability_id", using: :btree
  add_index "availability_day_of_week_availability", ["day_of_week_availability_id"], name: "index_availability_dow_availability_on_dow_availability_id", using: :btree

  create_table "day_of_week_availabilities", force: true do |t|
    t.integer  "day_of_week"
    t.string   "time_of_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_call_out_lists", force: true do |t|
    t.integer  "call_out_shift_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "filtered_at"
  end

  create_table "employee_call_out_results", force: true do |t|
    t.string   "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_call_outs", force: true do |t|
    t.integer  "employee_call_out_list_id"
    t.integer  "employee_id"
    t.boolean  "overtime",                    default: false
    t.boolean  "rejected",                    default: false
    t.string   "rule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_call_out_result_id"
    t.datetime "called_at"
    t.integer  "position"
  end

  add_index "employee_call_outs", ["employee_call_out_list_id"], name: "index_employee_call_outs_on_employee_call_out_list_id", using: :btree
  add_index "employee_call_outs", ["employee_call_out_result_id"], name: "index_employee_call_outs_on_employee_call_out_result_id", using: :btree
  add_index "employee_call_outs", ["employee_id"], name: "index_employee_call_outs_on_employee_id", using: :btree

  create_table "employee_shifts", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "shift_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "replaced_shift_id"
    t.integer  "shift_replacement_reason_id"
    t.string   "type"
  end

  add_index "employee_shifts", ["employee_id"], name: "index_employee_shifts_on_employee_id", using: :btree
  add_index "employee_shifts", ["replaced_shift_id"], name: "index_employee_shifts_on_replaced_shift_id", using: :btree
  add_index "employee_shifts", ["shift_id"], name: "index_employee_shifts_on_shift_id", using: :btree
  add_index "employee_shifts", ["shift_replacement_reason_id"], name: "index_employee_shifts_on_shift_replacement_reason_id", using: :btree

  create_table "employees", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "employee_class"
    t.string   "seniority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "enabled",             default: true
    t.date     "hire_date"
    t.string   "sin"
    t.date     "date_of_birth"
    t.string   "email"
    t.string   "address"
    t.string   "hourly_rate"
    t.string   "group"
    t.date     "registration_expiry"
    t.date     "first_aid_expiry"
    t.date     "whmis_expiry"
    t.date     "food_safe_expiry"
    t.date     "nvci_expiry"
    t.date     "crc_expiry"
    t.date     "evaluation_due"
  end

  create_table "employees_employees_roles", id: false, force: true do |t|
    t.integer "employee_id",       null: false
    t.integer "employees_role_id", null: false
  end

  add_index "employees_employees_roles", ["employee_id", "employees_role_id"], name: "index_on_employee_id_and_employees_role_id", using: :btree
  add_index "employees_employees_roles", ["employees_role_id", "employee_id"], name: "index_on_employees_role_id_and_employee_id", using: :btree

  create_table "employees_facilities", force: true do |t|
    t.integer "employee_id"
    t.integer "facility_id"
  end

  create_table "employees_roles", force: true do |t|
    t.string   "role_name"
    t.string   "role_abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",           default: true
  end

  create_table "facilities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "enabled",                default: true
    t.boolean  "has_shared_duty_shifts", default: false
  end

  create_table "facilities_users", force: true do |t|
    t.integer "user_id"
    t.integer "facility_id"
  end

  create_table "notes", force: true do |t|
    t.integer  "user_id"
    t.text     "note"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["employee_id"], name: "index_notes_on_employee_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "shift_replacement_reasons", force: true do |t|
    t.string   "reason"
    t.string   "abreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shift_types", force: true do |t|
    t.string   "name"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shifts", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "facility_id"
    t.integer  "employees_role_id"
    t.text     "schedule_store"
    t.integer  "start_hour"
    t.integer  "start_minute"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_of_day"
    t.integer  "shift_type_id"
  end

  add_index "shifts", ["employees_role_id"], name: "index_shifts_on_employees_role_id", using: :btree
  add_index "shifts", ["facility_id"], name: "index_shifts_on_facility_id", using: :btree
  add_index "shifts", ["shift_type_id"], name: "index_shifts_on_shift_type_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.boolean  "enabled",                default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
