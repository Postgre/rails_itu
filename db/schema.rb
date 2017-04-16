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

ActiveRecord::Schema.define(version: 20150810125227) do

  create_table "apps", force: true do |t|
    t.string   "client_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", force: true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["attachable_type", "attachable_id"], name: "index_assets_on_attachable_type_and_attachable_id", using: :btree

  create_table "business_scopes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates", force: true do |t|
    t.integer  "user_id"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_visible",                     default: true
    t.string   "city"
    t.integer  "country_id"
    t.integer  "availability",                   default: 2
    t.integer  "ems_student_id"
    t.string   "country_iso3"
    t.string   "region"
    t.boolean  "is_profile_complete",            default: false, null: false
    t.float    "latitude",            limit: 24
    t.float    "longitude",           limit: 24
    t.string   "address"
  end

  add_index "candidates", ["country_id"], name: "index_candidates_on_country_id", using: :btree
  add_index "candidates", ["ems_student_id"], name: "index_candidates_on_ems_student_id", using: :btree
  add_index "candidates", ["latitude", "longitude"], name: "index_candidates_on_latitude_and_longitude", using: :btree
  add_index "candidates", ["user_id"], name: "index_candidates_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about_us"
    t.string   "company_size"
    t.integer  "status",                      default: 0
    t.integer  "owner_user_id"
    t.string   "street_address"
    t.string   "street_address2"
    t.string   "city"
    t.string   "country"
    t.string   "postal_code"
    t.string   "phone_number"
    t.string   "email"
    t.string   "business_scope"
    t.boolean  "terms_of_service",            default: false
    t.string   "state",                                       null: false
    t.string   "logo"
    t.integer  "industry_id"
    t.integer  "country_id"
    t.string   "country_iso3"
    t.string   "region"
    t.float    "latitude",         limit: 24
    t.float    "longitude",        limit: 24
    t.string   "address"
  end

  add_index "companies", ["industry_id"], name: "index_companies_on_industry_id", using: :btree
  add_index "companies", ["latitude", "longitude"], name: "index_companies_on_latitude_and_longitude", using: :btree
  add_index "companies", ["state"], name: "index_companies_on_state", using: :btree

  create_table "company_reps", force: true do |t|
    t.integer  "company_id"
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_reps", ["company_id"], name: "index_company_reps_on_company_id", using: :btree
  add_index "company_reps", ["user_id", "company_id"], name: "index_company_reps_on_user_id_and_company_id", unique: true, using: :btree
  add_index "company_reps", ["user_id"], name: "index_company_reps_on_user_id", using: :btree

  create_table "courses", force: true do |t|
    t.integer  "candidate_id"
    t.string   "title"
    t.string   "department"
    t.string   "professor"
    t.text     "description"
    t.string   "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_visible",                default: true, null: false
    t.string   "grade"
    t.integer  "ems_courseterm_student_id"
  end

  add_index "courses", ["candidate_id"], name: "index_courses_on_candidate_id", using: :btree

  create_table "education_records", force: true do |t|
    t.integer  "candidate_id"
    t.string   "school"
    t.string   "city"
    t.integer  "start_year"
    t.integer  "end_year"
    t.string   "degree"
    t.string   "field_of_study"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_verified",    default: false
    t.boolean  "has_graduated",  default: false
    t.integer  "country_id"
    t.string   "country_iso3"
    t.string   "region"
  end

  add_index "education_records", ["candidate_id"], name: "index_education_records_on_candidate_id", using: :btree
  add_index "education_records", ["country_id"], name: "index_education_records_on_country_id", using: :btree

  create_table "employers", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "about_us"
    t.string   "street_address"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "country"
    t.string   "postal_code"
    t.string   "website"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employers", ["user_id"], name: "index_employers_on_user_id", using: :btree

  create_table "employment_records", force: true do |t|
    t.integer  "candidate_id"
    t.string   "company_name"
    t.string   "job_title"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_current_job", default: false
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.string   "country_iso3"
    t.string   "region"
  end

  add_index "employment_records", ["candidate_id"], name: "index_employment_records_on_candidate_id", using: :btree
  add_index "employment_records", ["country_id"], name: "index_employment_records_on_country_id", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  add_index "favorites", ["owner_id", "owner_type"], name: "index_favorites_on_owner_id_and_owner_type", using: :btree
  add_index "favorites", ["subject_id", "subject_type", "owner_id", "owner_type", "creator_id"], name: "uniq_favorites_idx", unique: true, using: :btree
  add_index "favorites", ["subject_id", "subject_type"], name: "index_favorites_on_subject_id_and_subject_type", using: :btree

  create_table "industries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interviews", force: true do |t|
    t.integer  "company_id"
    t.integer  "candidate_id"
    t.datetime "date",                                  null: false
    t.string   "location",                              null: false
    t.integer  "status",                    default: 0
    t.datetime "suggested_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "details"
    t.text     "notes"
    t.string   "state",                                 null: false
    t.integer  "job_id",                                null: false
    t.float    "latitude",       limit: 24
    t.float    "longitude",      limit: 24
    t.integer  "changer_id"
  end

  add_index "interviews", ["company_id"], name: "index_interviews_on_user_id_and_company_id", using: :btree
  add_index "interviews", ["job_id"], name: "index_interviews_on_job_id", using: :btree
  add_index "interviews", ["latitude", "longitude"], name: "index_interviews_on_latitude_and_longitude", using: :btree

  create_table "job_applications", force: true do |t|
    t.integer "candidate_id"
    t.integer "job_id"
    t.text    "cover_letter"
    t.string  "resume"
    t.string  "state"
  end

  add_index "job_applications", ["candidate_id"], name: "index_job_applications_on_candidate_id", using: :btree
  add_index "job_applications", ["job_id", "candidate_id"], name: "index_job_applications_on_job_id_and_candidate_id", unique: true, using: :btree
  add_index "job_applications", ["job_id"], name: "index_job_applications_on_job_id", using: :btree

  create_table "jobs", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "description"
    t.integer  "years"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_type"
    t.integer  "schedule"
    t.date     "start_date"
    t.string   "state"
    t.boolean  "is_public",                       default: true, null: false
    t.float    "latitude",             limit: 24
    t.float    "longitude",            limit: 24
    t.string   "location"
    t.datetime "last_state_change_at"
    t.datetime "published_at"
    t.integer  "user_id"
  end

  add_index "jobs", ["company_id"], name: "index_jobs_on_company_id", using: :btree
  add_index "jobs", ["latitude", "longitude"], name: "index_jobs_on_latitude_and_longitude", using: :btree
  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "link_types", force: true do |t|
    t.string   "link_type",  null: false
    t.string   "domain",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: true do |t|
    t.integer "candidate_id"
    t.string  "link_type",    default: "external-link", null: false
    t.string  "link",                                   null: false
  end

  create_table "mailboxer_conversation_opt_outs", force: true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "skill_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skill_category_records", force: true do |t|
    t.integer  "skill_category_id"
    t.string   "skill_categorizable_type"
    t.integer  "skill_categorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "skill_category_records", ["position"], name: "index_skill_category_records_on_position", using: :btree
  add_index "skill_category_records", ["skill_categorizable_type", "skill_categorizable_id"], name: "by_categorizable_type_categorizable_id", using: :btree
  add_index "skill_category_records", ["skill_category_id"], name: "by_skill_category_id", using: :btree

  create_table "skill_records", force: true do |t|
    t.integer  "skill_id"
    t.string   "skillable_type"
    t.integer  "skillable_id"
    t.integer  "level",                    default: 2,     null: false
    t.integer  "years_of_experience",      default: 1,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_featured",              default: false, null: false
    t.integer  "position"
    t.integer  "skill_category_record_id"
  end

  add_index "skill_records", ["level"], name: "index_skill_records_on_level", using: :btree
  add_index "skill_records", ["position"], name: "index_skill_records_on_position", using: :btree
  add_index "skill_records", ["skillable_type", "skillable_id"], name: "index_skill_records_on_skillable_type_and_skillable_id", using: :btree

  create_table "skills", force: true do |t|
    t.string   "name"
    t.integer  "skill_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "skill_records_count", default: 0, null: false
  end

  add_index "skills", ["skill_category_id"], name: "index_skills_on_skill_category_id", using: :btree

  create_table "time_zones", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "time_zone"
    t.string   "city"
    t.string   "country"
    t.boolean  "is_superuser",           default: false
    t.string   "phone_number"
    t.string   "email",                  default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "itu_id",                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "ems_user_id"
    t.string   "ems_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["ems_user_id"], name: "index_users_on_ems_user_id", using: :btree
  add_index "users", ["itu_id"], name: "index_users_on_itu_id", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  Foreigner.load
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", name: "mb_opt_outs_on_conversations_id", column: "conversation_id"

  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", name: "notifications_on_conversation_id", column: "conversation_id"

  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", name: "receipts_on_notification_id", column: "notification_id"

end
