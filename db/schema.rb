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

ActiveRecord::Schema.define(version: 2023_02_14_171039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_steps", force: :cascade do |t|
    t.string "title"
    t.bigint "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["chapter_id"], name: "index_action_steps_on_chapter_id"
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.integer "user_id"
    t.json "revisions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_activities_on_business_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "ad_reports", id: :serial, force: :cascade do |t|
    t.integer "impressions"
    t.integer "clicks"
    t.float "costs"
    t.integer "click_conversions"
    t.float "post_click_revenue"
    t.integer "view_conversions"
    t.float "post_view_revenue"
    t.string "ad_id"
    t.string "ad_name"
    t.string "ad_nid"
    t.string "ad_type"
    t.integer "conversions"
    t.float "revenue"
    t.float "ctr"
    t.float "cpc"
    t.float "conversion_rate"
    t.float "cpm"
    t.float "adjusted_post_click_revenue"
    t.float "adjusted_post_view_revenue"
    t.float "adjusted_conversion_revenue"
    t.integer "business_id"
    t.date "report_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_ad_reports_on_business_id"
  end

  create_table "addendums", force: :cascade do |t|
    t.bigint "agency_id"
    t.boolean "signed"
    t.string "file"
    t.string "signature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_addendums_on_agency_id"
  end

  create_table "addon_plans", force: :cascade do |t|
    t.bigint "package_id"
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "mandatory", default: false
    t.bigint "resource_id"
    t.string "resource_type"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "address_line_1"
    t.text "address_line_2"
    t.string "city"
    t.string "country"
    t.string "state"
    t.string "zip"
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "type"
    t.index ["addressable_type", "addressable_id", "type"], name: "index_addresses_on_addressable_type_and_addressable_id_and_type"
    t.index ["deleted_at"], name: "index_addresses_on_deleted_at"
  end

  create_table "admin_calendly_scripts", force: :cascade do |t|
    t.bigint "user_id"
    t.text "calendly_script"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admin_calendly_scripts_on_user_id"
  end

  create_table "admin_faqs", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
  end

  create_table "admin_payment_link_plans", force: :cascade do |t|
    t.string "description_line_1"
    t.string "description_line_2"
    t.float "amount"
    t.integer "billing_category"
    t.float "implementation_fee"
    t.boolean "pay_with_implementation_fee"
    t.string "stripe_plan_id"
    t.datetime "deleted_at"
    t.uuid "admin_payment_link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_payment_link_id"], name: "index_admin_payment_link_plans_on_admin_payment_link_id"
    t.index ["deleted_at"], name: "index_admin_payment_link_plans_on_deleted_at"
  end

  create_table "admin_payment_link_subscriptions", force: :cascade do |t|
    t.string "account_id"
    t.integer "amount", default: 0
    t.string "currency", default: "usd"
    t.string "customer"
    t.string "interval"
    t.string "status"
    t.integer "billing_category"
    t.jsonb "metadata"
    t.integer "billing_type"
    t.integer "quantity", default: 1
    t.datetime "canceled_at"
    t.datetime "cancel_at"
    t.string "implementation_invoice_id"
    t.bigint "admin_payment_link_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_payment_link_plan_id"], name: "index_admin_payment_link_plan_id"
  end

  create_table "admin_payment_links", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "status", default: 0
    t.boolean "disabled", default: false
    t.string "stripe_customer_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["deleted_at"], name: "index_admin_payment_links_on_deleted_at"
    t.index ["user_id"], name: "index_admin_payment_links_on_user_id"
  end

  create_table "agencies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "support_email"
    t.string "logo"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "square_logo"
    t.string "email_logo"
    t.integer "clients_limit", default: 10
    t.integer "keywords_limit", default: 1000
    t.integer "competitors_limit", default: 100
    t.string "domain"
    t.string "weburl"
    t.string "white_label_name"
    t.integer "level"
    t.string "customer_id"
    t.boolean "allow_client_duplication", default: false
    t.boolean "support_popup", default: false
    t.string "cname", default: ""
    t.string "yext_api_key"
    t.boolean "cname_verified", default: false
    t.string "kickoff_call_link"
    t.string "name_slug"
    t.boolean "white_labeled", default: false
    t.string "discovery_call_link"
    t.string "connect_call_link"
    t.string "grader_logo"
    t.datetime "last_logged_in"
    t.integer "last_logged_in_user_id"
    t.integer "referred_by"
    t.text "labels"
    t.datetime "deleted_at"
    t.text "enabled_packages", array: true
    t.boolean "case_study_enabled", default: false
    t.string "legal_name"
    t.boolean "portfolio_enabled", default: false
    t.text "calendly_script"
    t.text "enabled_document_categories", default: ["miscellaneous"], array: true
    t.string "home_link"
    t.integer "lead_strategy_limit"
    t.string "favicon"
    t.string "case_study_portfolio_header_color", default: "#4C4E60"
    t.string "strategy_product_header_color", default: "#007BBE"
    t.string "currency", default: "$"
    t.boolean "payment_links_enabled", default: false
    t.string "t_and_c_link"
    t.boolean "signup_approved", default: true
    t.text "niche_industry"
    t.boolean "scale_program", default: false
    t.string "strategy_product_background_color", default: "#007BBE"
    t.string "prospecting_call_link"
    t.text "facebook_pixel"
    t.integer "number_of_users"
    t.text "thank_you_facebook_pixel"
    t.integer "onboarding_checklist", array: true
    t.boolean "bundle_plans", default: false
    t.string "questionnaire_header_color", default: "#4C4E60"
    t.string "display_currency", default: "USD"
    t.boolean "scale_zoom_info", default: false
    t.boolean "onetime_charge", default: true
    t.boolean "support_prospecting_call", default: true
    t.datetime "scale_zoom_expiry_date"
    t.boolean "plans_enabled", default: true
    t.string "strategy_product_text_color", default: "#FFF"
    t.boolean "coaching_recordings", default: false
    t.boolean "start_agency_program", default: false
    t.boolean "is_social_media_ad", default: false
    t.text "thank_you_funnel"
    t.boolean "value_hook", default: false
    t.string "roi_header_color", default: "#4C4E60"
    t.integer "email_leads_count_limit", default: 0
    t.integer "send_email_leads_count", default: 0
    t.string "cold_email_domain_name"
    t.boolean "enable_cold_email", default: false
    t.boolean "moment_call", default: false
    t.boolean "agency_status", default: true
    t.boolean "coaching_calls_in_support_page", default: false
    t.string "time_zone_name", default: "UTC"
    t.string "start_time", default: "10:00 AM"
    t.string "end_time", default: "11:00 AM"
    t.string "funnel_calendlie"
    t.string "portfolio_calender_header"
    t.string "casestudy_calender_header"
    t.string "lead_calender_header"
    t.boolean "portfolio_limited_access", default: false
    t.boolean "case_study_limited_access", default: false
    t.string "niches"
    t.string "state"
    t.string "readymode_url"
    t.string "cold_email_sub_domain"
    t.boolean "readymode_enabled", default: false
    t.string "icebreaker_sentence", default: "write an icebreaker sentence before pitching my services to them."
    t.string "ai_bot_prompt_1"
    t.string "ai_bot_prompt_2"
    t.string "ai_bot_prompt_3"
    t.index ["deleted_at"], name: "index_agencies_on_deleted_at"
    t.index ["name_slug"], name: "index_agencies_on_name_slug", unique: true
  end

  create_table "agencies_courses", force: :cascade do |t|
    t.bigint "agency_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_agencies_courses_on_agency_id"
    t.index ["course_id"], name: "index_agencies_courses_on_course_id"
  end

  create_table "agency_admin_business_email_preferences", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_agency_admin_business_email_preferences_on_business_id"
    t.index ["user_id"], name: "index_agency_admin_business_email_preferences_on_user_id"
  end

  create_table "agency_niches", force: :cascade do |t|
    t.bigint "agency_id"
    t.bigint "industry_id"
    t.text "lead_form"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_agency_niches_on_agency_id"
    t.index ["industry_id"], name: "index_agency_niches_on_industry_id"
  end

  create_table "agency_niches_accesses", force: :cascade do |t|
    t.bigint "agency_id"
    t.boolean "full_access"
    t.integer "industries_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_agency_niches_accesses_on_agency_id"
  end

  create_table "agency_profiles", force: :cascade do |t|
    t.bigint "agency_id"
    t.string "estd_date"
    t.string "core_services"
    t.string "value_proposition"
    t.string "preferred_niche"
    t.text "niche_description"
    t.text "niche_lookup_keyword"
    t.text "customer_pain_points"
    t.text "decision_makers"
    t.text "niche_directories"
    t.string "client_call_source"
    t.text "challenges"
    t.string "monthly_revenue"
    t.text "monthly_revenue_goal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_agency_profiles_on_agency_id"
  end

  create_table "agreements", force: :cascade do |t|
    t.boolean "signed"
    t.string "file"
    t.string "signature"
    t.string "agreementable_type"
    t.bigint "agreementable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "version"
    t.index ["agreementable_type", "agreementable_id"], name: "index_agreements_on_agreementable_type_and_agreementable_id"
  end

  create_table "answers", id: :serial, force: :cascade do |t|
    t.string "answer"
    t.string "oneliner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
    t.integer "questionnaire_id"
    t.integer "question_v_id"
    t.text "paragraph"
    t.boolean "boolean_ans"
    t.string "mcq"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["questionnaire_id"], name: "index_answers_on_questionnaire_id"
  end

  create_table "backlink_data", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.json "summary"
    t.json "backlinks"
    t.json "anchor_text"
    t.json "topics"
    t.json "pages"
    t.json "ref_domains"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "summary_updated_at"
    t.datetime "backlinks_updated_at"
    t.datetime "anchor_text_updated_at"
    t.datetime "topics_updated_at"
    t.datetime "pages_updated_at"
    t.datetime "ref_domains_updated_at"
    t.json "anchor_chart_data"
    t.datetime "anchor_chart_data_updated_at"
    t.json "anchor_word_cloud"
    t.datetime "anchor_word_cloud_updated_at"
    t.index ["business_id"], name: "index_backlink_data_on_business_id"
  end

  create_table "backlink_histories", id: :serial, force: :cascade do |t|
    t.integer "total", default: 0
    t.integer "gained", default: 0
    t.integer "lost", default: 0
    t.date "tracked_date", null: false
    t.integer "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "badges_sashes", id: :serial, force: :cascade do |t|
    t.integer "badge_id"
    t.integer "sash_id"
    t.boolean "notified_user", default: false
    t.datetime "created_at"
    t.index ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id"
    t.index ["badge_id"], name: "index_badges_sashes_on_badge_id"
    t.index ["sash_id"], name: "index_badges_sashes_on_sash_id"
  end

  create_table "blacklisted_domains", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bundle_packages", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.text "sales_pitch"
    t.boolean "sales_pitch_enabled", default: false
    t.integer "category"
    t.float "implementation_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "white_glove_fees"
    t.text "questionnaire_categories", default: [], array: true
  end

  create_table "bundle_plans", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.string "product_name"
    t.float "amount"
    t.integer "billing_category"
    t.string "interval"
    t.string "stripe_plan"
    t.string "package_name"
    t.string "package_type"
    t.float "min_recommended_price"
    t.boolean "business_required"
    t.boolean "white_glove_service", default: false
    t.string "display_tag"
    t.float "onetime_charge"
    t.bigint "bundle_package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "iterations"
    t.index ["bundle_package_id"], name: "index_bundle_plans_on_bundle_package_id"
  end

  create_table "business_hours", id: :serial, force: :cascade do |t|
    t.string "days"
    t.string "status"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "from", default: "", null: false
    t.string "to", default: "", null: false
    t.index ["location_id"], name: "index_business_hours_on_location_id"
  end

  create_table "business_keywords", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.integer "keyword_id"
    t.string "tags"
    t.integer "keyword_rankings_count"
    t.datetime "deleted_at"
    t.integer "deleted_by"
    t.index ["business_id", "keyword_id"], name: "by_business_and_keyword", unique: true
    t.index ["deleted_at"], name: "index_business_keywords_on_deleted_at"
  end

  create_table "businesses", id: :serial, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "agency_id"
    t.boolean "local_profile_service", default: false
    t.boolean "seo_service", default: false
    t.boolean "call_analytics_service", default: false
    t.string "call_analytics_id"
    t.string "unique_id"
    t.string "google_analytics_id"
    t.boolean "contents_service", default: true
    t.boolean "trial_service", default: false
    t.date "trial_expiry_date"
    t.string "site_url", default: "", null: false
    t.string "adword_client_id"
    t.float "adword_cost_markup", default: 0.0
    t.string "labels"
    t.string "adword_campaign_ids", default: [], array: true
    t.datetime "deleted_at"
    t.boolean "backlink_service", default: false
    t.string "domain"
    t.string "logo"
    t.string "slug"
    t.string "target_city"
    t.boolean "managed_seo_service", default: false
    t.boolean "managed_ppc_service", default: false
    t.integer "keyword_limit", default: 10
    t.boolean "site_audit_service", default: false
    t.integer "competitors_limit", default: 5
    t.integer "total_pages_crawled", default: 500
    t.string "customer_id"
    t.string "timezone", default: "Central Time (US & Canada)"
    t.float "ppc_budget", default: 0.0
    t.integer "locations_count", default: 0
    t.integer "keywords_count", default: 0
    t.string "fb_access_token"
    t.string "fb_access_secret"
    t.string "leo_project_id"
    t.boolean "competitors_service", default: true
    t.string "ga_sub"
    t.string "sc_sub"
    t.boolean "free_service", default: false
    t.integer "last_logged_in_user_id"
    t.datetime "last_logged_in"
    t.boolean "facebook_ad_service", default: true
    t.integer "fb_ad_account_id"
    t.float "fb_budget", default: 0.0
    t.string "callrail_id"
    t.string "callrail_account_id"
    t.string "callrail_company_id"
    t.boolean "dummy", default: false
    t.boolean "reputation_service", default: false
    t.string "locale", default: "en-us"
    t.integer "custom_plan_id"
    t.string "contact_mailing_list", default: [], array: true
    t.integer "monitor_id"
    t.boolean "automate_adword_campaign", default: true
    t.string "legal_name"
    t.string "home_link"
    t.boolean "keyword_ranking_service", default: true
    t.float "fb_ad_cost_markup", default: 0.0
    t.string "semrush_project_id"
    t.string "semrush_project_url"
    t.string "google_ads_customer_client_id"
    t.string "google_ads_login_customer_id"
    t.string "tracking_page_path"
    t.datetime "keywords_last_viewed_at"
    t.index ["agency_id"], name: "index_businesses_on_agency_id"
    t.index ["deleted_at"], name: "index_businesses_on_deleted_at"
    t.index ["name"], name: "index_businesses_on_name"
  end

  create_table "businesses_users", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id", "user_id"], name: "index_businesses_users_on_business_id_and_user_id"
  end

  create_table "case_studies", force: :cascade do |t|
    t.string "title", null: false
    t.string "descriptive_image"
    t.text "description"
    t.bigint "industry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "detailed_description"
    t.integer "tier"
    t.datetime "deleted_at"
    t.integer "status", default: 0
    t.text "internal_note"
    t.string "service"
    t.text "services", default: [], array: true
    t.string "short_desc"
    t.string "stat1_text"
    t.string "stat1_value"
    t.string "stat2_text"
    t.string "stat2_value"
    t.string "stat3_text"
    t.string "stat3_value"
    t.bigint "assignee_id"
    t.integer "agency_id", default: 0
    t.integer "network_profile_id"
    t.text "in_their_words"
    t.index ["agency_id"], name: "index_case_studies_on_agency_id"
    t.index ["assignee_id"], name: "index_case_studies_on_assignee_id"
    t.index ["industry_id"], name: "index_case_studies_on_industry_id"
    t.index ["network_profile_id"], name: "index_case_studies_on_network_profile_id"
  end

  create_table "case_study_images", force: :cascade do |t|
    t.string "file"
    t.bigint "case_study_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_study_id"], name: "index_case_study_images_on_case_study_id"
  end

  create_table "case_study_industries", force: :cascade do |t|
    t.bigint "case_study_id"
    t.bigint "industry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_study_id"], name: "index_case_study_industries_on_case_study_id"
    t.index ["industry_id"], name: "index_case_study_industries_on_industry_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.string "title"
    t.text "video_embed_code"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.integer "position"
    t.integer "course_challenge_id"
    t.index ["course_id"], name: "index_chapters_on_course_id"
  end

  create_table "chat_messages", force: :cascade do |t|
    t.bigint "chat_thread_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.boolean "read", default: false
    t.index ["chat_thread_id"], name: "index_chat_messages_on_chat_thread_id"
    t.index ["receiver_id"], name: "index_chat_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_chat_messages_on_sender_id"
  end

  create_table "chat_templates", force: :cascade do |t|
    t.string "template_name"
    t.string "template_data"
  end

  create_table "chat_threads", force: :cascade do |t|
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["agency_id"], name: "index_chat_threads_on_agency_id"
    t.index ["user_id"], name: "index_chat_threads_on_user_id"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "clickx_packages", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.text "sales_pitch"
    t.boolean "sales_pitch_enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clickx_plans", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.string "product_name"
    t.float "amount"
    t.integer "billing_category"
    t.string "interval"
    t.string "stripe_plan"
    t.string "package_name"
    t.string "package_type"
    t.float "implementation_fee"
    t.string "display_tag"
    t.bigint "clickx_package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cold_email_automate_sedning_reports", force: :cascade do |t|
    t.string "name"
    t.bigint "cold_email_batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cold_email_batch_id"], name: "index_cold_email_batch_report"
  end

  create_table "cold_email_batches", force: :cascade do |t|
    t.string "name"
    t.integer "batch_size"
    t.integer "record_count"
    t.integer "status", default: 0
    t.bigint "lead_source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lead_source_id"], name: "index_cold_email_batches_on_lead_source_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "comment"
    t.integer "content_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name", null: false
    t.index ["content_id"], name: "index_comments_on_content_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "competitions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "business_id"
    t.json "summary", default: {}, null: false
    t.json "backlinks", default: [], null: false
    t.json "anchor_text", default: {}, null: false
    t.json "top_pages", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "keywords_organic", default: [], null: false
    t.json "keywords_adwords", default: [], null: false
    t.string "logo", default: ""
    t.json "anchor_text_data"
    t.index ["business_id"], name: "index_competitions_on_business_id"
  end

  create_table "completed_action_steps", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "action_step_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_step_id"], name: "index_completed_action_steps_on_action_step_id"
    t.index ["user_id"], name: "index_completed_action_steps_on_user_id"
  end

  create_table "content_order_defaults", id: :serial, force: :cascade do |t|
    t.string "company_information"
    t.string "target_audience"
    t.string "things_to_mention"
    t.string "things_to_avoid"
    t.integer "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_content_order_defaults_on_business_id"
  end

  create_table "content_orders", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.json "form_data"
    t.integer "order_status", default: 0
    t.integer "payment_status", default: 0
    t.string "payment_information"
    t.datetime "paid_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_order_id"
    t.float "order_price"
    t.integer "user_id"
    t.index ["business_id"], name: "index_content_orders_on_business_id"
    t.index ["user_id"], name: "index_content_orders_on_user_id"
  end

  create_table "contents", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.string "state"
    t.text "content"
    t.integer "business_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "meta_title"
    t.text "meta_description"
    t.index ["business_id"], name: "index_contents_on_business_id"
  end

  create_table "contractors_invites", force: :cascade do |t|
    t.string "email"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone"
    t.integer "created_by"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email_template_name"
    t.string "source"
    t.string "shortcode"
    t.string "workable_id"
    t.boolean "mail_status", default: false
    t.integer "send_by_user"
    t.datetime "workable_created_at"
    t.datetime "workable_updated_at"
    t.string "url"
    t.boolean "unsubscribed", default: false
    t.index ["created_by"], name: "index_contractors_invites_on_created_by"
    t.index ["deleted_at"], name: "index_contractors_invites_on_deleted_at"
    t.index ["email"], name: "index_contractors_invites_on_email", unique: true
  end

  create_table "course_challenges", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.integer "tier"
    t.text "permitted_agencies_ids", default: [], array: true
    t.integer "resource_type"
    t.text "permitted_resources_ids", default: [], array: true
    t.string "access_tip"
    t.integer "week"
    t.boolean "show_on_recording", default: false
    t.integer "video_category_type", default: 0
    t.boolean "enable_challenge", default: false
  end

  create_table "custom_packages", force: :cascade do |t|
    t.string "name"
    t.float "amount"
    t.float "implementation_fee"
    t.text "description"
    t.integer "status", default: 0
    t.string "package_name", null: false
    t.bigint "agency_id"
    t.bigint "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "billing_category"
    t.string "stripe_plan"
    t.text "questionnaire_categories", default: [], array: true
    t.index ["agency_id"], name: "index_custom_packages_on_agency_id"
    t.index ["business_id"], name: "index_custom_packages_on_business_id"
  end

  create_table "custom_urls", id: :serial, force: :cascade do |t|
    t.string "website_url"
    t.string "campaign_source"
    t.string "campaign_medium"
    t.string "campaign_name"
    t.string "campaign_term"
    t.string "campaign_content"
    t.string "complete_url"
    t.integer "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "direct_leads", force: :cascade do |t|
    t.string "name"
    t.string "base_domain"
    t.string "base_url"
    t.string "root_url"
    t.bigint "lead_source_id"
    t.datetime "viewed_at"
    t.integer "domain_contacts_count", default: 0
    t.boolean "mark_as_send", default: false
    t.boolean "emailed", default: false
    t.bigint "contacted_by_id"
    t.bigint "skipped_by_id"
    t.datetime "contacted_at"
    t.datetime "skipped_at"
    t.datetime "blocked_at"
    t.boolean "wordpress"
    t.datetime "voice_mailed_at"
    t.bigint "voice_mailed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "screenshot_image"
    t.boolean "converted", default: false
    t.datetime "rejected_at"
    t.integer "rejected_by"
    t.index ["deleted_at"], name: "index_direct_leads_on_deleted_at"
    t.index ["lead_source_id"], name: "index_direct_leads_on_lead_source_id"
  end

  create_table "document_attachments", force: :cascade do |t|
    t.string "file"
    t.integer "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tier"
    t.text "permitted_agencies_ids", default: [], array: true
    t.integer "category"
    t.string "document_link"
    t.boolean "is_admin_type", default: false
    t.integer "agency_id", default: 0
  end

  create_table "domain_contacts", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "company"
    t.string "email"
    t.string "base_domain"
    t.string "phone"
    t.string "first_name"
    t.string "last_name"
    t.text "email_content"
    t.bigint "sender_id"
    t.datetime "email_sent_at"
    t.string "contactable_type"
    t.integer "verified_by"
    t.datetime "verified_at"
    t.boolean "unsubscribed", default: false
    t.datetime "email_opened_at"
    t.integer "email_clicks_count"
    t.string "email_sent_from"
    t.bigint "rejected_by_id"
    t.datetime "rejected_at"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "instagram"
    t.integer "direct_lead_id"
    t.datetime "send_at"
    t.bigint "cold_email_batch_id"
    t.boolean "is_invalid_email", default: false
    t.integer "created_type", default: 0
    t.datetime "delivery_at"
    t.string "city"
    t.integer "sent_emails_count", default: 0, null: false
    t.index ["cold_email_batch_id"], name: "index_domain_contacts_on_cold_email_batch_id"
    t.index ["deleted_at"], name: "index_domain_contacts_on_deleted_at"
    t.index ["sender_id"], name: "index_domain_contacts_on_sender_id"
  end

  create_table "domain_rankings", force: :cascade do |t|
    t.string "keyword_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "domain"
    t.integer "rank"
  end

  create_table "email_click_events", force: :cascade do |t|
    t.datetime "clicked_at"
    t.string "sg_event_id"
    t.json "metadata", default: {}
    t.bigint "domain_contact_id"
    t.index ["domain_contact_id"], name: "index_email_click_events_on_domain_contact_id"
  end

  create_table "email_preferences", id: :serial, force: :cascade do |t|
    t.integer "ownable_id"
    t.string "key"
    t.string "email_frequency", default: "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "feature"
    t.string "ownable_type"
    t.boolean "enabled", default: true, null: false
    t.boolean "feature_microscope", default: false, null: false
    t.integer "recurring", default: 0, null: false
    t.index ["ownable_id"], name: "index_email_preferences_on_ownable_id"
  end

  create_table "email_templates", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.string "subject"
    t.text "wordpress_site_custom_content"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.index ["agency_id"], name: "index_email_templates_on_agency_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "mailer_name"
    t.string "title"
    t.text "to_addresses", default: [], array: true
    t.text "cc_addresses", default: [], array: true
    t.text "bcc_addresses", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facebook_ad_images", force: :cascade do |t|
    t.string "file"
    t.boolean "heading", default: false
    t.bigint "facebook_ad_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_ad_id"], name: "index_facebook_ad_images_on_facebook_ad_id"
  end

  create_table "facebook_ads", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category_type", default: "FacebookAds"
    t.boolean "is_taken", default: false
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.string "section"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
  end

  create_table "favorite_case_studies", force: :cascade do |t|
    t.bigint "case_study_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_study_id"], name: "index_favorite_case_studies_on_case_study_id"
    t.index ["user_id"], name: "index_favorite_case_studies_on_user_id"
  end

  create_table "favorite_courses", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_favorite_courses_on_course_id"
    t.index ["user_id"], name: "index_favorite_courses_on_user_id"
  end

  create_table "favorite_industries", force: :cascade do |t|
    t.bigint "industry_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_favorite_industries_on_industry_id"
    t.index ["user_id"], name: "index_favorite_industries_on_user_id"
  end

  create_table "fb_ad_accounts", force: :cascade do |t|
    t.string "account_id"
    t.integer "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "campaign_ids", default: [], array: true
  end

  create_table "fb_ad_reports", force: :cascade do |t|
    t.integer "clicks"
    t.integer "inline_link_clicks"
    t.integer "impressions"
    t.float "ctr"
    t.float "cpc"
    t.float "spend"
    t.float "reach"
    t.float "frequency"
    t.float "conversion"
    t.date "report_date", null: false
    t.bigint "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_fb_ad_reports_on_business_id"
  end

  create_table "file_attachments", force: :cascade do |t|
    t.string "file"
    t.string "file_attachable_type"
    t.bigint "file_attachable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filename"
    t.index ["file_attachable_type", "file_attachable_id"], name: "file_attachable_index"
  end

  create_table "fixed_plans", force: :cascade do |t|
    t.bigint "agency_id"
    t.bigint "package_id"
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_fixed_plans_on_agency_id"
    t.index ["package_id"], name: "index_fixed_plans_on_package_id"
    t.index ["plan_id"], name: "index_fixed_plans_on_plan_id"
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

  create_table "funnel_pages", force: :cascade do |t|
    t.string "title"
    t.string "section_a"
    t.string "section_b"
    t.string "section_c"
    t.string "section_d"
    t.string "section_e"
    t.string "section_f"
    t.string "css"
    t.boolean "draft", default: true
    t.bigint "industry_id"
    t.boolean "lead_form_required"
    t.bigint "agency_id"
    t.bigint "funnel_page_id"
    t.index ["agency_id"], name: "index_funnel_pages_on_agency_id"
    t.index ["funnel_page_id"], name: "index_funnel_pages_on_funnel_page_id"
    t.index ["industry_id"], name: "index_funnel_pages_on_industry_id"
  end

  create_table "google_ad_reports", force: :cascade do |t|
    t.integer "impressions"
    t.integer "interactions"
    t.float "interaction_rate"
    t.float "avg_cost"
    t.float "cost"
    t.float "conversion"
    t.date "report_date", null: false
    t.bigint "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_google_ad_reports_on_business_id"
  end

  create_table "grader_reports", id: :serial, force: :cascade do |t|
    t.jsonb "desktop_insights", default: {}
    t.jsonb "mobile_insights", default: {}
    t.jsonb "landing_page", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "backlinks", default: {}
    t.jsonb "organic_competitors", default: {}
    t.jsonb "adwords_competitors", default: {}
    t.string "domain"
    t.integer "reportable_id"
    t.string "reportable_type"
    t.integer "status"
    t.datetime "deleted_at"
    t.string "google_api_version"
    t.index ["deleted_at"], name: "index_grader_reports_on_deleted_at"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.integer "user_id"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "file"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "title", null: false
    t.string "icon_klass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inquiry_answers", force: :cascade do |t|
    t.string "client_questionnaire_id"
    t.bigint "question_id"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "client_id"
  end

  create_table "inquiry_client_questionnaires", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inquiry_linked_questions", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.bigint "question_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inquiry_questionnaires", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inquiry_questions", force: :cascade do |t|
    t.text "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "blurb"
    t.boolean "required", default: true
    t.string "element_type", default: "text_area"
    t.string "tab_to_show"
  end

  create_table "integration_details", force: :cascade do |t|
    t.jsonb "details", default: {}
    t.bigint "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_integration_details_on_business_id"
  end

  create_table "intelligence_caches", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.jsonb "best_performing_ads", default: []
    t.jsonb "contacts_overview", default: {}
    t.jsonb "contacts_per_day", default: {}
    t.jsonb "new_contacts_by_source", default: {}
    t.jsonb "top_10_keywords", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "last_30_days_google_analytics"
    t.jsonb "last_30_days_google_search_console"
    t.jsonb "last_30_days_adwords_ppc_summary"
    t.jsonb "last_30_days_business_competitiors"
    t.jsonb "last_30_days_backlinks"
    t.jsonb "reviews_stars"
    t.jsonb "datewise_rankings"
    t.jsonb "last_30_days_call_analytics"
    t.jsonb "last_30_days_adwords_display_summary"
    t.index ["business_id"], name: "index_intelligence_caches_on_business_id"
  end

  create_table "ip_addresses", id: :serial, force: :cascade do |t|
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keyword_rankings", id: :serial, force: :cascade do |t|
    t.integer "google_rank"
    t.integer "google_change"
    t.text "google_url"
    t.date "rank_date"
    t.integer "business_keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "search_volume"
    t.string "cpc"
    t.integer "all_time_google_change"
    t.integer "this_month_google_change"
    t.integer "last_30_days_google_change"
    t.integer "last_sevendays_google_change"
    t.datetime "google_callback_updated_at"
    t.json "google_raw_data"
    t.integer "keyword_id"
    t.index ["keyword_id", "google_rank", "rank_date"], name: "idx_google_rank_combination"
    t.index ["keyword_id"], name: "index_keyword_rankings_on_keyword_id"
  end

  create_table "keyword_tags", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id"
    t.index ["business_id"], name: "index_keyword_tags_on_business_id"
  end

  create_table "keywords", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "kdi"
    t.datetime "kdi_updated_at"
    t.integer "business_id"
    t.datetime "deleted_at"
    t.integer "deleted_by"
    t.bigint "keyword_tag_id"
    t.boolean "active", default: true
    t.string "type"
    t.date "last_updated"
    t.string "locale"
    t.index ["active"], name: "index_keywords_on_active"
    t.index ["business_id"], name: "index_keywords_on_business_id"
    t.index ["deleted_at"], name: "index_keywords_on_deleted_at"
    t.index ["keyword_tag_id"], name: "index_keywords_on_keyword_tag_id"
    t.index ["name", "city"], name: "index_keywords_on_name_and_city"
    t.index ["name"], name: "index_keywords_on_name"
  end

  create_table "lead_source_email_templates", force: :cascade do |t|
    t.bigint "email_template_id"
    t.bigint "lead_source_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_template_id"], name: "index_lead_source_email_templates_on_email_template_id"
    t.index ["lead_source_id"], name: "index_lead_source_email_templates_on_lead_source_id"
  end

  create_table "lead_source_files", force: :cascade do |t|
    t.string "filename"
    t.bigint "lead_source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lead_source_id"], name: "index_lead_source_files_on_lead_source_id"
  end

  create_table "lead_sources", force: :cascade do |t|
    t.string "name"
    t.string "subject"
    t.string "sequence_id"
    t.string "closeio_user_id"
    t.string "from_email"
    t.boolean "enabled", default: true
    t.date "end_date"
    t.text "email_template"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "agency_id"
    t.string "cold_email_verify_number"
    t.datetime "cold_email_verify_at"
    t.integer "total_email_leads_count", default: 0
    t.integer "send_email_leads_count", default: 0
    t.text "word_press"
    t.integer "remaining_count", default: 0
    t.integer "batch_size", default: 10
    t.boolean "enable_automate", default: false
    t.string "from_email_name"
    t.index ["agency_id"], name: "index_lead_sources_on_agency_id"
    t.index ["deleted_at"], name: "index_lead_sources_on_deleted_at"
  end

  create_table "lead_strategies", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "category"
    t.integer "status"
    t.bigint "lead_id"
    t.text "strategies", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "ad_spend_info"
    t.string "created_by"
    t.datetime "deleted_at"
    t.index ["lead_id"], name: "index_lead_strategies_on_lead_id"
  end

  create_table "lead_strategy_funnels", force: :cascade do |t|
    t.string "funnel_type"
    t.string "category"
    t.string "content"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lead_strategy_items", force: :cascade do |t|
    t.integer "category"
    t.text "strategy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "favorite", default: false
  end

  create_table "leads", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.string "email", null: false
    t.string "company"
    t.string "phone"
    t.string "domain"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value"
    t.integer "status", default: 0
    t.text "campaign_info", default: [], array: true
    t.text "competitor_info", default: [], array: true
    t.text "next_steps", default: [], array: true
    t.text "call_notes"
    t.text "current_info"
    t.datetime "deleted_at"
    t.text "goals_and_expectations"
    t.text "comment"
    t.datetime "next_meeting_date"
    t.string "audit_request"
    t.bigint "business_id"
    t.boolean "old_strategy", default: false
    t.string "stripe_customer_id"
    t.index ["agency_id"], name: "index_leads_on_agency_id"
    t.index ["deleted_at"], name: "index_leads_on_deleted_at"
  end

  create_table "leo_api_data", id: :serial, force: :cascade do |t|
    t.integer "business_id"
    t.string "project_id"
    t.json "issues_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_crawl_created_at"
    t.json "detailed_report"
    t.string "ssl_presence"
    t.string "xml_sitemap"
    t.string "version_check"
    t.string "check_robots"
    t.integer "site_audit_issue_id"
    t.string "error_response"
    t.index ["business_id"], name: "index_leo_api_data_on_business_id"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zip"
    t.string "phone"
    t.string "mobile_phone"
    t.string "toll_free"
    t.string "website"
    t.string "enquiry_email"
    t.string "fax"
    t.string "categories", default: [], array: true
    t.string "payment_methods", default: [], array: true
    t.string "products_services", default: [], array: true
    t.string "brands", default: [], array: true
    t.string "images", default: [], array: true
    t.string "languages", default: [], array: true
    t.string "professional_associations", default: [], array: true
    t.text "slogan"
    t.text "keywords"
    t.text "short_description"
    t.text "medium_description"
    t.text "full_description"
    t.text "long_description"
    t.bigint "number_of_users"
    t.integer "year_established"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_id"
    t.string "local_profile_list"
    t.datetime "local_profile_last_upload"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.string "yext_store_id"
    t.json "yext_listings", default: {}, null: false
    t.string "bright_local_report_id"
    t.boolean "operational_hours", default: false
    t.string "positive_review_coupon"
    t.string "negative_review_coupon"
    t.string "slug"
    t.string "short_url"
    t.integer "reviews_count"
    t.json "bl_reviews_info", default: {}, null: false
    t.float "average_rating"
    t.string "contact_name"
    t.json "bright_local_lisiting", default: {}, null: false
    t.string "bright_local_campaign_id"
    t.json "yext_info", default: {}
    t.json "yext_reviews_info", default: {}
    t.index ["business_id"], name: "index_locations_on_business_id"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "logins", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "username"
    t.string "password"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_id"
    t.index ["business_id"], name: "index_logins_on_business_id"
  end

  create_table "mail_templates", id: :serial, force: :cascade do |t|
    t.text "paragraph1"
    t.string "mail_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "welcome_text", default: "", null: false
    t.text "agency_note", default: "", null: false
    t.string "subject"
    t.index ["user_id"], name: "index_mail_templates_on_user_id"
  end

  create_table "mailgun_subdomains", force: :cascade do |t|
    t.string "subdomain", null: false
    t.text "user_name_ciphertext", null: false
    t.text "password_ciphertext", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marketing_performance_goals", id: :serial, force: :cascade do |t|
    t.integer "visits_per_month"
    t.integer "contacts_per_month"
    t.integer "customers_per_month"
    t.integer "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_marketing_performance_goals_on_business_id"
  end

  create_table "merit_actions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "action_method"
    t.integer "action_value"
    t.boolean "had_errors", default: false
    t.string "target_model"
    t.integer "target_id"
    t.text "target_data"
    t.boolean "processed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", id: :serial, force: :cascade do |t|
    t.integer "action_id"
    t.string "related_change_type"
    t.integer "related_change_id"
    t.string "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", id: :serial, force: :cascade do |t|
    t.integer "score_id"
    t.integer "num_points", default: 0
    t.string "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", id: :serial, force: :cascade do |t|
    t.integer "sash_id"
    t.string "category", default: "default"
  end

  create_table "negative_domains", force: :cascade do |t|
    t.string "name"
    t.boolean "ignored", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "network_memberships", force: :cascade do |t|
    t.bigint "network_profile_id"
    t.boolean "community_joined"
    t.boolean "publish_blog"
    t.boolean "fb_profile_add"
    t.boolean "social_links_add"
    t.boolean "post_about_network"
    t.boolean "personal_social_links_add"
    t.boolean "linkedin_add"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["network_profile_id"], name: "index_network_memberships_on_network_profile_id"
  end

  create_table "network_portfolios", force: :cascade do |t|
    t.bigint "network_profile_id"
    t.string "heading"
    t.text "paragraph"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["network_profile_id"], name: "index_network_portfolios_on_network_profile_id"
  end

  create_table "network_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.text "description"
    t.string "available_hours"
    t.string "time_period"
    t.string "cv"
    t.string "background_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "overview"
    t.string "legal_name"
    t.json "stats", default: {}
    t.string "linkedin"
    t.string "facebook"
    t.string "instagram"
    t.string "dribbble"
    t.integer "start_tour"
    t.index ["user_id"], name: "index_network_profiles_on_user_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "action", null: false
    t.integer "user_id"
    t.integer "actor_id"
    t.string "actor_type"
    t.integer "target_id"
    t.string "target_type"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_type", "actor_id"], name: "index_notifications_on_actor_type_and_actor_id"
    t.index ["target_type", "target_id"], name: "index_notifications_on_target_type_and_target_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "onboarding_checklists", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.bigint "onboarding_section_id"
    t.index ["onboarding_section_id"], name: "index_onboarding_checklists_on_onboarding_section_id"
  end

  create_table "onboarding_procedures", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_id"
    t.integer "agency_id"
    t.bigint "package_subscription_id"
  end

  create_table "onboarding_sections", force: :cascade do |t|
    t.string "title"
  end

  create_table "onboarding_tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "task"
    t.integer "position"
    t.boolean "completed", default: false
    t.bigint "onboarding_procedure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["onboarding_procedure_id"], name: "index_onboarding_tasks_on_onboarding_procedure_id"
  end

  create_table "outscraper_limits", force: :cascade do |t|
    t.integer "credit_balance", default: 0
    t.integer "download_limit", default: 5
    t.integer "max_requests", default: 5
    t.integer "total_downloads", default: 0
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_outscraper_limits_on_agency_id"
  end

  create_table "outscrapper_bulk_data", force: :cascade do |t|
    t.bigint "lead_source_id"
    t.string "filename"
    t.jsonb "cleaned_data"
    t.boolean "status_success", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lead_source_id"], name: "index_outscrapper_bulk_data_on_lead_source_id"
  end

  create_table "outscrapper_categories", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outscrapper_data", force: :cascade do |t|
    t.bigint "outscrapper_request_id"
    t.jsonb "response_json"
    t.jsonb "cleaned_json"
    t.datetime "created_at", default: "2023-02-25 18:16:03", null: false
    t.datetime "updated_at", default: "2023-02-25 18:16:03", null: false
    t.boolean "deleted_at"
    t.jsonb "readymode_response"
    t.bigint "agency_id"
    t.index ["agency_id"], name: "index_outscrapper_data_on_agency_id"
    t.index ["outscrapper_request_id"], name: "index_outscrapper_data_on_outscrapper_request_id"
  end

  create_table "outscrapper_requests", force: :cascade do |t|
    t.bigint "agency_id"
    t.string "external_requests_id", null: false
    t.string "outscrapper_status"
    t.text "request_query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "categories", array: true
    t.string "states", array: true
    t.string "cities", array: true
    t.integer "limit", default: 0
    t.integer "lead_source_id"
    t.boolean "deleted_at"
    t.integer "readymode_upload_status", default: 0
    t.string "zip_codes", default: ""
    t.integer "created_by"
    t.index ["agency_id"], name: "index_outscrapper_requests_on_agency_id"
    t.index ["created_by"], name: "index_outscrapper_requests_on_created_by"
  end

  create_table "package_subscriptions", force: :cascade do |t|
    t.string "account_id"
    t.string "plan_id"
    t.integer "amount", default: 0
    t.string "currency", default: "usd"
    t.string "customer"
    t.string "interval"
    t.string "status"
    t.integer "billing_category"
    t.jsonb "metadata"
    t.string "package_name"
    t.integer "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "implementation_invoice_id"
    t.integer "business_id"
    t.jsonb "custom_package_info"
    t.integer "custom_package_id"
    t.integer "package_type"
    t.boolean "expedited_onboarding", default: false
    t.float "expedited_onboarding_fee"
    t.integer "billing_type"
    t.datetime "deleted_at"
    t.float "onetime_charge"
    t.string "onetime_charge_invoice_id"
    t.bigint "package_id"
    t.string "package_class"
    t.string "recipient_type"
    t.integer "quantity", default: 1
    t.string "funnel_platform"
    t.datetime "canceled_at"
    t.datetime "cancel_at"
    t.index ["deleted_at"], name: "index_package_subscriptions_on_deleted_at"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.text "sales_pitch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sales_pitch_enabled", default: false
    t.integer "category"
    t.text "questionnaire_categories", default: [], array: true
    t.text "ensure_checklist", array: true
  end

  create_table "payment_details", id: :serial, force: :cascade do |t|
    t.string "payment_type", default: "credit_card"
    t.integer "business_id"
    t.string "email"
    t.string "card_token"
    t.string "card_info"
    t.string "stripe_customer_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_payment_details_on_business_id"
  end

  create_table "payment_link_plans", force: :cascade do |t|
    t.string "description_line_1"
    t.string "description_line_2"
    t.float "amount"
    t.integer "billing_category"
    t.float "implementation_fee"
    t.boolean "pay_with_implementation_fee"
    t.string "stripe_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "payment_link_id"
    t.index ["deleted_at"], name: "index_payment_link_plans_on_deleted_at"
  end

  create_table "payment_link_subscriptions", force: :cascade do |t|
    t.string "account_id"
    t.integer "amount", default: 0
    t.string "currency", default: "usd"
    t.string "customer"
    t.string "interval"
    t.string "status"
    t.integer "billing_category"
    t.jsonb "metadata"
    t.integer "billing_type"
    t.integer "quantity", default: 1
    t.datetime "canceled_at"
    t.datetime "cancel_at"
    t.bigint "agency_id"
    t.bigint "payment_link_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "implementation_invoice_id"
    t.index ["agency_id"], name: "index_payment_link_subscriptions_on_agency_id"
    t.index ["payment_link_plan_id"], name: "index_payment_link_subscriptions_on_payment_link_plan_id"
  end

  create_table "payment_links", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.boolean "disabled", default: false
    t.datetime "deleted_at"
    t.bigint "resource_id"
    t.string "resource_type"
    t.bigint "business_user_id"
    t.string "user_name"
    t.string "user_email"
    t.string "stripe_customer_id"
    t.index ["agency_id"], name: "index_payment_links_on_agency_id"
    t.index ["deleted_at"], name: "index_payment_links_on_deleted_at"
  end

  create_table "payments", force: :cascade do |t|
    t.string "stripe_id"
    t.integer "amount", default: 0
    t.string "currency", default: "usd"
    t.string "description"
    t.string "customer"
    t.string "interval"
    t.string "status"
    t.integer "billing_category"
    t.jsonb "metadata"
    t.bigint "agency_id"
    t.bigint "business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "package_subscription_id"
    t.string "stripe_object_type"
    t.datetime "deleted_at"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.string "product_name"
    t.float "amount"
    t.integer "billing_category"
    t.string "interval"
    t.string "stripe_plan"
    t.string "package_name"
    t.string "package_type"
    t.float "implementation_fee"
    t.float "min_recommended_price"
    t.boolean "business_required"
    t.string "display_tag"
    t.bigint "package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "onetime_charge"
    t.integer "iterations"
    t.index ["package_id"], name: "index_plans_on_package_id"
  end

  create_table "portfolio_images", force: :cascade do |t|
    t.string "file"
    t.bigint "portfolio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_portfolio_images_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.integer "category"
    t.integer "tier"
    t.datetime "deleted_at"
    t.boolean "draft"
    t.text "video_embed_code"
    t.integer "agency_id", default: 0
    t.index ["agency_id"], name: "index_portfolios_on_agency_id"
    t.index ["deleted_at"], name: "index_portfolios_on_deleted_at"
  end

  create_table "privacy_policies", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_proposals", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid", default: false
    t.index ["project_id"], name: "index_project_proposals_on_project_id"
    t.index ["user_id"], name: "index_project_proposals_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "agency_id"
    t.string "title"
    t.string "type_of_employment"
    t.text "description"
    t.float "budget"
    t.string "primary_skill"
    t.string "specific_primary_skill"
    t.string "other_skill"
    t.string "specific_other_skill"
    t.string "other_skill_2"
    t.string "specific_other_skill_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "short_desc"
    t.string "project_type"
    t.integer "accepted_proposal_id"
    t.index ["accepted_proposal_id"], name: "index_projects_on_accepted_proposal_id"
    t.index ["agency_id"], name: "index_projects_on_agency_id"
  end

  create_table "questionnaires", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_id"
    t.index ["business_id"], name: "index_questionnaires_on_business_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.string "question"
    t.string "description"
    t.string "exp_ans_type"
    t.boolean "is_published", default: false
    t.boolean "is_mandatory", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.integer "group_id"
    t.string "mcq_choices", default: [], array: true
    t.integer "position"
    t.index ["group_id"], name: "index_questions_on_group_id"
  end

  create_table "referrals", id: :serial, force: :cascade do |t|
    t.integer "referrer_id"
    t.integer "referee_id"
    t.boolean "eligibility", default: false
    t.boolean "rewarded", default: false
    t.string "notes", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reminder_emails", id: :serial, force: :cascade do |t|
    t.datetime "last_email_sent_at"
    t.integer "email_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_id"
    t.index ["business_id"], name: "index_reminder_emails_on_business_id"
  end

  create_table "review_links", force: :cascade do |t|
    t.string "link_type", null: false
    t.string "link", null: false
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_review_links_on_location_id"
  end

  create_table "reviews", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "rating"
    t.string "email"
    t.integer "location_id"
    t.string "phone_number"
    t.string "review_id"
    t.string "report_id"
    t.string "directory"
    t.datetime "timestamp"
    t.string "source_link"
    t.string "title"
    t.string "author"
    t.text "text"
    t.string "link"
    t.string "source"
    t.string "url"
    t.string "name"
    t.text "unique_hash"
    t.datetime "dt"
    t.index ["location_id", "unique_hash"], name: "index_reviews_on_location_id_and_unique_hash", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "sashes", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scale_program_headers", force: :cascade do |t|
    t.string "name"
    t.integer "week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_result_rankings", force: :cascade do |t|
    t.string "href"
    t.string "base_url"
    t.string "title"
    t.string "description"
    t.integer "rank"
    t.integer "last_7_days"
    t.integer "last_14_days"
    t.integer "last_30_days"
    t.integer "search_term_id"
    t.date "rank_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "semrush_keywords", force: :cascade do |t|
    t.bigint "business_id"
    t.string "name"
    t.float "cpc"
    t.integer "last_day_google_change"
    t.integer "search_volume"
    t.integer "kdi"
    t.integer "rank"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "kdi_last_updated_at"
    t.date "search_volume_last_updated_at"
    t.index ["business_id"], name: "index_semrush_keywords_on_business_id"
  end

  create_table "sent_emails", force: :cascade do |t|
    t.text "content"
    t.string "subject"
    t.bigint "sender_id"
    t.bigint "verified_by"
    t.datetime "verified_at"
    t.datetime "email_sent_at"
    t.string "from_email"
    t.datetime "email_opened_at"
    t.datetime "email_queued_at"
    t.integer "email_clicks_count", default: 0
    t.string "sent_via_service"
    t.bigint "domain_contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_contact_id"], name: "index_sent_emails_on_domain_contact_id"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "signup_links", force: :cascade do |t|
    t.float "onetime_charge"
    t.string "plan_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category"
    t.string "coupon_code"
    t.integer "discount_type"
    t.string "trial_interval"
    t.integer "trial_interval_count"
    t.boolean "disabled"
    t.date "expires_on"
    t.text "title"
    t.text "calendly_script"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "company"
    t.boolean "paid", default: false
    t.integer "extended_count", default: 0
    t.float "discount_by", default: 500.0
    t.integer "onetime_charge_duration"
    t.float "down_payment"
    t.boolean "reusable_link", default: false
    t.bigint "sales_rep_id"
    t.boolean "send_invite", default: false
    t.index ["sales_rep_id"], name: "index_signup_links_on_sales_rep_id"
  end

  create_table "site_audit_details", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "h_tags"
    t.string "images"
    t.string "cta"
    t.string "page_links"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_audit_issue_infos", id: :serial, force: :cascade do |t|
    t.string "error_description"
    t.string "issue_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "passed_description"
    t.string "error_title"
    t.string "passed_title"
  end

  create_table "site_audit_issues", force: :cascade do |t|
    t.string "url"
    t.float "readability_score"
    t.integer "errors_count"
    t.integer "warning_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "page_id"
    t.integer "leo_api_datum_id"
    t.integer "backlinks_count"
    t.integer "keywords"
    t.integer "traffic_metrics"
    t.string "readability_note"
    t.integer "passed_count"
    t.index ["leo_api_datum_id"], name: "index_site_audit_issues_on_leo_api_datum_id"
    t.index ["page_id"], name: "index_site_audit_issues_on_page_id"
  end

  create_table "site_audit_reports", force: :cascade do |t|
    t.integer "site_audit_issue_id"
    t.jsonb "title"
    t.jsonb "description"
    t.jsonb "h_tags"
    t.jsonb "images"
    t.jsonb "cta"
    t.jsonb "page_links"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_audit_issue_id"], name: "index_site_audit_reports_on_site_audit_issue_id"
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "network_profile_id"
    t.string "name"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["network_profile_id"], name: "index_skills_on_network_profile_id"
  end

  create_table "social_links", id: :serial, force: :cascade do |t|
    t.string "link_type", null: false
    t.string "link", null: false
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_social_links_on_location_id"
  end

  create_table "social_media_prompts", force: :cascade do |t|
    t.string "title"
    t.string "prompt"
  end

  create_table "state_trackers", id: :serial, force: :cascade do |t|
    t.string "from_state"
    t.string "to_state"
    t.datetime "transition_date"
    t.integer "content_id", null: false
    t.integer "user_id", null: false
    t.string "user_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_state_trackers_on_content_id"
    t.index ["user_id"], name: "index_state_trackers_on_user_id"
  end

  create_table "strategy_images", force: :cascade do |t|
    t.uuid "lead_strategy_id", null: false
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lead_strategy_id"], name: "index_strategy_images_on_lead_strategy_id"
  end

  create_table "stripe_credentials", force: :cascade do |t|
    t.string "publishable_key"
    t.string "secret_key"
    t.string "payment_links_product_id"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_stripe_credentials_on_agency_id"
  end

  create_table "subscription_accounts", force: :cascade do |t|
    t.string "account_id"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "canceled_at"
    t.boolean "cancel_at_period_end"
    t.datetime "ended_at"
    t.string "plan_id"
    t.string "plan_name"
    t.integer "amount", default: 0
    t.string "currency", default: "usd"
    t.string "interval"
    t.integer "interval_count", default: 0
    t.integer "trial_period_days", default: 0
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.integer "status"
    t.integer "billing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "set_as_free", default: false
    t.integer "accountable_id"
    t.string "accountable_type"
  end

  create_table "subscription_coupons", force: :cascade do |t|
    t.string "coupon_id"
    t.string "duration"
    t.integer "amount_off"
    t.string "currency", default: "usd"
    t.integer "duration_in_months"
    t.integer "max_redemptions"
    t.integer "percent_off"
    t.datetime "redeem_by"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.string "name"
    t.string "plan_id"
    t.string "currency", default: "usd"
    t.string "interval"
    t.integer "amount", default: 0
    t.integer "interval_count", default: 0
    t.string "statement_descriptor"
    t.integer "trial_period_days", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plan_type", default: 0
    t.json "metadata", default: {}
    t.boolean "public", default: false
  end

  create_table "subscription_schedules", force: :cascade do |t|
    t.string "stripe_id"
    t.integer "status"
    t.string "stripe_plan"
    t.datetime "start_at"
    t.jsonb "metadata"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_subscription_schedules_on_agency_id"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.string "plan_name"
    t.string "plan_handle"
    t.integer "business_id"
    t.string "chargify_sub_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_subscriptions_on_business_id"
  end

  create_table "support_members", force: :cascade do |t|
    t.string "name"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["agency_id"], name: "index_support_members_on_agency_id"
    t.index ["deleted_at"], name: "index_support_members_on_deleted_at"
  end

  create_table "tag_colors", force: :cascade do |t|
    t.string "tag", null: false
    t.string "color", null: false
    t.integer "business_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_tag_colors_on_business_id"
  end

  create_table "taggables", force: :cascade do |t|
    t.integer "keyword_id"
    t.integer "keyword_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id", "keyword_tag_id"], name: "index_taggables_on_keyword_id_and_keyword_tag_id", unique: true
    t.index ["keyword_id"], name: "index_taggables_on_keyword_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.string "sub_tasks", default: [], array: true
    t.string "state"
    t.integer "business_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "task_type"
    t.index ["business_id"], name: "index_tasks_on_business_id"
  end

  create_table "thumbnails", force: :cascade do |t|
    t.string "file"
    t.string "thumbnailable_type"
    t.bigint "thumbnailable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thumbnailable_type", "thumbnailable_id"], name: "index_thumbnails_on_thumbnailable_type_and_thumbnailable_id"
  end

  create_table "todo_items", force: :cascade do |t|
    t.bigint "todo_list_id"
    t.text "content"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "position"
    t.index ["todo_list_id"], name: "index_todo_items_on_todo_list_id"
  end

  create_table "todo_lists", force: :cascade do |t|
    t.bigint "agency_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_todo_lists_on_agency_id"
  end

  create_table "tokens", id: :serial, force: :cascade do |t|
    t.string "code_type"
    t.string "access_token"
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "expires_at"
    t.datetime "issued_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_id"
    t.string "sub"
    t.index ["business_id"], name: "index_tokens_on_business_id"
  end

  create_table "twillio_chat_threads", force: :cascade do |t|
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "blocked", default: false
    t.boolean "unread", default: false
  end

  create_table "twillio_contacts", force: :cascade do |t|
    t.string "name"
    t.string "phone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "twillio_messages", id: false, force: :cascade do |t|
    t.string "sid", null: false
    t.integer "status"
    t.string "body"
    t.string "from"
    t.string "to"
    t.bigint "twillio_chat_thread_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["sid"], name: "index_twillio_messages_on_sid", unique: true
    t.index ["twillio_chat_thread_id"], name: "index_twillio_messages_on_twillio_chat_thread_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "role"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.text "address"
    t.string "phone"
    t.string "unique_id"
    t.integer "ownable_id"
    t.boolean "preview_user", default: false
    t.string "fb_access_token"
    t.string "fb_access_secret"
    t.string "twitter_access_token"
    t.string "twitter_access_secret"
    t.boolean "email_alert", default: false
    t.string "autopilot_contact_id"
    t.string "authy_id"
    t.datetime "last_sign_in_with_authy"
    t.boolean "authy_enabled", default: false
    t.datetime "last_seen"
    t.string "linkedin_access_token"
    t.string "linkedin_access_secret"
    t.string "google_plus_access_token"
    t.string "google_plus_access_secret"
    t.string "ownable_type"
    t.string "selected_fb_pages", default: [], array: true
    t.string "selected_linkedin_pages", default: [], array: true
    t.integer "sash_id"
    t.integer "level", default: 0
    t.string "token"
    t.string "logo"
    t.string "provider"
    t.string "uid"
    t.string "referral_code"
    t.string "referral_link", default: ""
    t.boolean "enable_dummy_business", default: false
    t.datetime "deleted_at"
    t.boolean "full_access", default: false
    t.boolean "agency_super_admin", default: false
    t.boolean "admin_approved"
    t.string "department"
    t.string "stripe_user_id"
    t.string "sign_in_token"
    t.datetime "sign_in_token_sent_at"
    t.string "otp_token"
    t.string "t_shirt_size"
    t.string "birth_day"
    t.string "birth_month"
    t.index ["authy_id"], name: "index_users_on_authy_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id", "invited_by_type"], name: "index_users_on_invited_by_id_and_invited_by_type"
    t.index ["ownable_id", "ownable_type"], name: "index_users_on_ownable_id_and_ownable_type"
    t.index ["ownable_id"], name: "index_users_on_ownable_id"
    t.index ["referral_code"], name: "index_users_on_referral_code", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_courses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_users_courses_on_course_id"
    t.index ["user_id"], name: "index_users_courses_on_user_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "value_hooks", force: :cascade do |t|
    t.string "title"
    t.string "internal_title"
    t.text "video_embed_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "agency_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "embed_code"
    t.text "description"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "watch_histories", force: :cascade do |t|
    t.datetime "first_seen"
    t.datetime "last_seen"
    t.bigint "course_id"
    t.bigint "chapter_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_watch_histories_on_chapter_id"
    t.index ["course_id"], name: "index_watch_histories_on_course_id"
    t.index ["user_id"], name: "index_watch_histories_on_user_id"
  end

  create_table "web_developments", force: :cascade do |t|
    t.integer "web_development_id"
    t.string "project_name"
    t.string "project_url"
    t.string "project_detail"
    t.bigint "agency_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_web_developments_on_agency_id"
    t.index ["user_id"], name: "index_web_developments_on_user_id"
  end

  create_table "webpush_subscriptions", id: :serial, force: :cascade do |t|
    t.string "endpoint"
    t.string "p256dh"
    t.string "auth"
    t.boolean "user_visible_only", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_webpush_subscriptions_on_user_id"
  end

  create_table "welcome_banners", force: :cascade do |t|
    t.text "body_text"
    t.string "body_link"
    t.string "body_bg_color"
    t.string "body_text_color"
    t.string "call_to_action"
    t.string "body_link_color"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "expiry_date_time"
  end

  create_table "work_profiles", force: :cascade do |t|
    t.bigint "network_profile_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["network_profile_id"], name: "index_work_profiles_on_network_profile_id"
  end

  create_table "workable_jobs", id: :string, force: :cascade do |t|
    t.string "full_title"
    t.string "department"
    t.string "url"
    t.string "shortcode"
    t.datetime "workable_created_at"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workable_webhooks", force: :cascade do |t|
    t.string "target_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "writer_forms", id: :serial, force: :cascade do |t|
    t.json "product_type", default: {}
    t.json "industry", default: {}
    t.json "specialty", default: {}
    t.json "field_layout", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "proofreading_cost"
    t.float "two_star_writer"
    t.float "three_star_writer"
    t.float "four_star_writer"
    t.float "five_star_writer"
    t.float "six_star_writer"
    t.float "markup_percentage"
  end

  add_foreign_key "action_steps", "chapters"
  add_foreign_key "addendums", "agencies"
  add_foreign_key "admin_payment_links", "users"
  add_foreign_key "agency_admin_business_email_preferences", "businesses"
  add_foreign_key "agency_admin_business_email_preferences", "users"
  add_foreign_key "agency_niches", "agencies"
  add_foreign_key "agency_niches", "industries"
  add_foreign_key "agency_niches_accesses", "agencies"
  add_foreign_key "agency_profiles", "agencies"
  add_foreign_key "business_hours", "locations"
  add_foreign_key "case_study_industries", "case_studies"
  add_foreign_key "case_study_industries", "industries"
  add_foreign_key "chat_messages", "chat_threads"
  add_foreign_key "chat_messages", "users", column: "receiver_id"
  add_foreign_key "chat_messages", "users", column: "sender_id"
  add_foreign_key "chat_threads", "agencies"
  add_foreign_key "chat_threads", "users"
  add_foreign_key "completed_action_steps", "action_steps"
  add_foreign_key "completed_action_steps", "users"
  add_foreign_key "domain_contacts", "cold_email_batches"
  add_foreign_key "domain_contacts", "users", column: "sender_id"
  add_foreign_key "email_templates", "agencies"
  add_foreign_key "facebook_ad_images", "facebook_ads"
  add_foreign_key "favorite_case_studies", "case_studies"
  add_foreign_key "favorite_case_studies", "users"
  add_foreign_key "favorite_industries", "industries"
  add_foreign_key "favorite_industries", "users"
  add_foreign_key "funnel_pages", "industries"
  add_foreign_key "intelligence_caches", "businesses"
  add_foreign_key "keyword_tags", "businesses"
  add_foreign_key "keywords", "keyword_tags"
  add_foreign_key "lead_source_email_templates", "email_templates"
  add_foreign_key "lead_source_email_templates", "lead_sources"
  add_foreign_key "lead_sources", "agencies"
  add_foreign_key "marketing_performance_goals", "businesses"
  add_foreign_key "network_memberships", "network_profiles"
  add_foreign_key "network_portfolios", "network_profiles"
  add_foreign_key "network_profiles", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "outscraper_limits", "agencies"
  add_foreign_key "outscrapper_data", "agencies"
  add_foreign_key "outscrapper_requests", "agencies"
  add_foreign_key "portfolio_images", "portfolios"
  add_foreign_key "project_proposals", "projects"
  add_foreign_key "project_proposals", "users"
  add_foreign_key "projects", "agencies"
  add_foreign_key "semrush_keywords", "businesses"
  add_foreign_key "sent_emails", "domain_contacts"
  add_foreign_key "signup_links", "users", column: "sales_rep_id"
  add_foreign_key "skills", "network_profiles"
  add_foreign_key "strategy_images", "lead_strategies"
  add_foreign_key "todo_items", "todo_lists"
  add_foreign_key "todo_lists", "agencies"
  add_foreign_key "web_developments", "agencies"
  add_foreign_key "web_developments", "users"
  add_foreign_key "webpush_subscriptions", "users"
  add_foreign_key "work_profiles", "network_profiles"
end
