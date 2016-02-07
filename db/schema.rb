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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131011165553) do

  create_table "accounts", :force => true do |t|
    t.string   "internal_id"
    t.string   "name"
    t.string   "period"
    t.integer  "max_users"
    t.integer  "voice_questions"
    t.integer  "included_candidates"
    t.decimal  "monthly_price",       :precision => 8, :scale => 2
    t.decimal  "candidate_price",     :precision => 8, :scale => 2
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "answers", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "candidate_id"
    t.string   "content"
    t.integer  "question_id"
  end

  create_table "calls", :force => true do |t|
    t.string   "sid"
    t.string   "status"
    t.integer  "candidate_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "campaign_questions", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "question_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "option"
  end

  add_index "campaign_questions", ["campaign_id"], :name => "index_campaign_questions_on_campaign_id"
  add_index "campaign_questions", ["question_id"], :name => "index_campaign_questions_on_question_id"

  create_table "campaigns", :force => true do |t|
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "recruiter_id"
    t.boolean  "active",               :default => true
    t.string   "position_name"
    t.string   "uid"
    t.date     "deadline"
    t.boolean  "recommend_friends"
    t.integer  "sent_invitations",     :default => 0
    t.boolean  "candidate_references"
    t.boolean  "receive_applications", :default => false
    t.boolean  "forward_applications", :default => false
    t.string   "company_name"
    t.boolean  "gateway"
    t.text     "min_age"
    t.text     "max_age"
    t.text     "gender"
    t.text     "max_salary"
    t.text     "civil_status"
  end

  create_table "candidates", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "campaign_id"
    t.string   "name"
    t.boolean  "completed_interview",        :default => false
    t.datetime "interview_completed_at"
    t.boolean  "accepted",                   :default => false
    t.boolean  "rejected",                   :default => false
    t.string   "uid"
    t.string   "surname"
    t.boolean  "privacy_consent"
    t.boolean  "completed_text_interview",   :default => false
    t.boolean  "completed_verbal_interview", :default => false
    t.string   "recommended_friends"
    t.string   "phone_number"
    t.string   "call_sid"
    t.string   "called_number"
    t.integer  "organization_id"
    t.string   "cel"
    t.boolean  "completed_filter_interview"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "friends", :force => true do |t|
    t.string   "email"
    t.integer  "candidate_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "guides", :force => true do |t|
    t.string   "name"
    t.string   "subject"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issues", :force => true do |t|
    t.string   "category"
    t.string   "section"
    t.string   "content"
    t.string   "interview_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "email"
    t.string   "recruiter_type"
    t.integer  "campaign_id"
    t.integer  "recruiter_id"
    t.string   "name"
    t.boolean  "active",         :default => true
  end

  create_table "message_recipients", :force => true do |t|
    t.string   "email"
    t.integer  "message_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "recruiter_id"
  end

  create_table "messages", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "recruiter_id"
    t.string   "interview_id"
    t.string   "sender_name"
  end

  create_table "organization_accounts", :force => true do |t|
    t.integer  "account_id"
    t.integer  "organization_id"
    t.integer  "anniversary_day"
    t.integer  "anniversary_month"
    t.integer  "anniversary_year"
    t.integer  "current_users",         :default => 0
    t.integer  "current_candidates",    :default => 0
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "additional_candidates", :default => 0
  end

  create_table "organizations", :force => true do |t|
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "name"
    t.boolean  "active",     :default => true
    t.integer  "account_id"
  end

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.string   "surname_paternal"
    t.string   "surname_maternal"
    t.date     "dob"
    t.string   "gender"
    t.string   "estado_civil"
    t.string   "desired_salary"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "candidate_id"
  end

  create_table "question_answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "question_answers", ["answer_id"], :name => "index_question_answers_on_answer_id"
  add_index "question_answers", ["question_id"], :name => "index_question_answers_on_question_id"

  create_table "questions", :force => true do |t|
    t.string   "content"
    t.string   "kind"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "category_id"
  end

  create_table "recruiters", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "name"
    t.integer  "organization_id"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "new_user",               :default => true
  end

  add_index "recruiters", ["email"], :name => "index_recruiters_on_email", :unique => true
  add_index "recruiters", ["reset_password_token"], :name => "index_recruiters_on_reset_password_token", :unique => true

  create_table "references", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "candidate_id"
    t.string   "relationship"
  end

end
