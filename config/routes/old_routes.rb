module OldRoutes
  def self.extended(router)
    router.instance_exec do
      # Auth routes
      get 'auth/facebook/callback', to: 'tokens#facebook_oauth_callback'
      # get '/auth/:provider/callback', to: 'integrations#create'
      get 'oauth2callback' => 'tokens#google_oauth_callback'
      # Support both GET and POST for callbacks

      get '/auth/failure' do
        flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
        redirect '/'
      end

      # Admin routes
      match :admin_config, to: 'admins#admin', via: %i[get post]
      delete 'destroy_ip/:id', to: 'admins#destroy_ip', as: 'destroy_ip'
      get :users_list, to: 'admins#users_list'

      # Signup
      get :free, to: 'signups#new_smb_signup'
      get :signup, to: 'signups#new_smb_signup'

      # Switching between accounts
      get :switch_to_admin_user, to: 'home#switch_to_admin_user'
      get :switch_to_agency_user, to: 'home#switch_to_agency_user'
      get :switch_to_business_user, to: 'home#switch_to_business_user'

      get 'change_current_business/:business_id', to: 'users#change_current_business'

      # You can have the root of your site routed with "root"
      get :clients, to: 'home#clients'

      # User routes

      resources :users, only: %i[index edit update destroy] do
        member do
          put :resend_invitation
          get :email_settings
          get :admin_users
          get :get_businesses
          put :update_logo
          put :update_basic_info
        end
        collection do
          get :get_user
          get :business_users
          # get :audit_report
        end
        resources :email_preferences, only: %i[create update]
      end
      resources :users, path: 'agency_admins', only: [] do
        resources :businesses, only: [] do
          member do
            get :email_preferences
          end
        end
      end

      get 'email_settings' => 'users#email_settings'

      # Agency routes

      resources :agencies do
        # resources :leads
        member do
          post :add_client
          patch :verify_cname
        end
        collection do
          get :get_businesses
          get :agency_admins
          get :get_users
          post :update_client
          post :add_keywords
          post :add_competitors
          delete :destroy_client
          get :get_agency_limits
          get :client_questionnaires
        end
        resources :businesses, only: [] do
          member do
            get :agency_email_settings
          end
        end
      end
      resources :agency_admin_business_email_preference, only: [] do
        resources :email_preferences
      end

      # Questionnaire
      resources :groups
      resources :questions
      resource :questionnaires

      # Location and reviews
      resources :reviews, only: %i[new create destroy] do
        member do
          post :send_mail
        end
      end
      post :send_mail, to: 'reviews#send_mail_with_id'
      resources :locations do
        member do
          put :set_yext_id
          get :yext_listings
          get :yext_info
          put :set_brightlocal_id
          get :reviews
          get :sitewise_reviews
          get :star_counts
          get :reviews_count
          get :reviews_growth
          get :dir_reviews
          get :reviews_by_stars
          get :top_reviews
          put :set_bright_local_campaign_id
          get :bright_local_listings
          get '/scan/:site_id', to: 'locations#scan'
          post :order, to: 'locations#set_order'
        end
        collection do
          get :get_all_locations
          get :brightlocal_locations
          get :locations_with_average_rating
          post :business_hour
        end
      end
      get 'local_profile_locations' => 'locations#local_profile_locations'
      get 'get_service_location' => 'locations#get_service_location'
      get '/:business_id/:id/',
          to: 'reviews#new',
          constraints: { host: ENV['REVIEWS_URL'] }

      # CSV Export

      get 'export_csv/:id' => 'locations#export_csv'
      get 'export_backlinks_csv/:id' => 'competitions#export_backlinks_csv'
      get 'export_top_pages_csv/:id' => 'competitions#export_top_pages_csv'
      get 'export_keywords_organic_csv/:id' => 'competitions#export_keywords_organic_csv'
      get 'export_keywords_adwords_csv/:id' => 'competitions#export_keywords_adwords_csv'

      namespace :tokens do
        post :store_analytics_info
        post :store_search_console_info
      end

      post :authoritylabs_callback, to: 'authority_labs#callback'
      post :delayed_keyword_ranking_callback, to: 'authority_labs#delayed_keyword_ranking'
      post :priority_keyword_ranking_callback, to: 'authority_labs#priority_keyword_ranking'

      post :delayed_search_result_ranking_callback, to: 'authority_labs#delayed_search_result_ranking'
      post :priority_search_result_ranking_callback, to: 'authority_labs#priority_search_result_ranking'

      get :current_business_dashboard, to: 'application#current_business_dashboard'

      # Tasks
      resources :tasks do
        get 'change_state/:new_state', action: 'change_state', on: :member
      end

      # Keyword Controller Under business

      get '/businesses/keyword_locations', to: 'businesses/keywords#locations'

      # changing time zone from business management

      # Competitions
      resources :competitions, except: :index do
        collection do
          get :business_competitions
          get :export_competitors_csv
        end
        member do
          get :competitors_history
          get :competition_keywords
        end
      end

      resources :businesses, only: [] do
        resources :competitions do
          collection do
            get :potential_competitors
            get :potential_keywords
            get :common_backlinks
          end
        end
      end

      # Business routes

      resources :businesses do
        member do
          get 'activity_list'
          get 'all_info'
          get 'get_calls'
          get 'unarchive'
          get 'force_delete'
          get 'google_analytics'
          get 'google_search_analytics'
          get 'google_referral_analytics'
          get 'google_locale_analytics'
          get 'google_goal_analytics'
          get 'google_social_overview'
          get 'google_social_overview_urls'
          get 'google_social_landing'
          get 'google_landing_pages'
          get 'google_social_network_referral'
          get 'google_search_console'
          get 'google_search_console_pages'
          get 'google_acquisition_campaigns'
          get 'google_source_medium', to: 'businesses/source_medium#google_source_medium'
          get 'yext_listings'
          get 'crawl_errors'
          get 'crawl_errors_csv'
          get 'sitemaps'
          get 'call_details/:call_id', action: 'get_call_details', as: 'call_details'
          get 'call_audio/:call_id', action: 'get_call_audio', as: 'call_audio'
          put 'update_logo'
          get 'clear_yext_cache'
          get 'backlinks_summary'
          get 'backlinks'
          get 'backlinks_history'
          get 'top_pages', to: 'businesses/backlinks#top_pages'
          get 'anchor_text_page', to: 'businesses/backlinks#anchor_text_page'
          get 'anchor_text_word_cloud'
          get 'anchor_text'
          get 'get_logins_data'
          get 'topics', to: 'businesses/backlinks#topics'
          get 'ref_domains', to: 'businesses/backlinks#ref_domains'
          get 'crawl_summary'
          get 'site_audit_detail_page'
          post 'add_to_keyword_bank'
          get 'google_analytics_settings_change'
          get 'google_search_console_settings_change'
          get 'business_keywords'
          get 'competitor_ranks'
          post 'delete_business_keyword'
          get 'get_datewise_rankings'
          get 'export_kr_to_csv'
          get 'keywords_list'
          get 'keyword_suggestions'
          post 'edit_keyword'
          post 'save_facebook_token'
          get 'get_business_time'
          post 'update_timezone'
          get 'business_users'
          get 'reviews_stars'
          post 'set_budget'
          get 'marketing_performance'
          get 'keyword_rank_history'
          put 'update_business'
          get 'new_backlinks'
          get 'lost_backlinks'
          get :locations
          resources :keyword_ranking_exports, only: :index
          namespace :google_analytics_exports do
            resources :overview, only: :index
            resources :search_analytics, only: :index
            resources :top_pages, only: :index
            resources :referrals, only: :index
            resources :campaigns, only: :index
            resources :locales, only: :index
            resources :goals, only: :index
            resources :socials, only: :index
          end
          post :add_domain
          get :wishlist_keywords
          resource :integration_detail, only: [:show, :update]
          get 'weekly_report_preview'
        end
        collection do
          get 'archived_list'
          get 'set_google_auth_paths'
          get 'get_business_report'
          post 'leo_audit_callback'
          get 'get_site_ids'
          post 'client_traction'
          get 'deleted_business_keywords'
          post 'update_keyword'
          get :get_total_labels
          get :set_labels, to: 'businesses#reinitilize_labels_set'
          get :ownable_businesses_list
          post :save_adword_campaign_ids
          post :send_support_email
        end

        resource :marketing_performance_goal
        resources :rank_summaries, only: :index
        resources :facebook_leads, only: %i[index] do
          collection do
            put :update_access_token
            delete :delete_access_token
            get :subscribed_pages
          end
        end
      end

      resources :onboarding_procedures do
        collection do
          get :assigned
        end
      end
      resources :onboarding_tasks do
        member do
          post :toggle_status
        end
      end

      resources :search_terms

      # Content order
      resources :content_order do
        member do
          get :place_order_admin
          get :stripe_payment, to: 'payment_details#stripe_payment'
          put :stripe_payment, to: 'payment_details#stripe_payment'
        end
        collection do
          get :complete_orders
          post :calculate_article_price, action: :calculate_article_price
          get :form_data
          post :business_cards_list, action: :business_cards_list
        end
      end

      resources :content_order_defaults, only: %i[show update create] do
        collection do
          get :default_by_business
        end
      end

      resources :payment_details, only: %i[show index destroy]
      resources :writer_forms do
        collection do
          get :get_writer_form
          put :update_writer_form
        end
      end

      resources :contents do
        get 'change_state/:new_state', action: 'change_state', on: :member
        put 'add_comment', action: 'add_comment', on: :member
      end

      namespace :fb_ads do
        resources :ads, only: [:index, :destroy] do
          collection do
            get :ad_preview
          end
        end
        get '/fb_account_status' => 'facebook#account_status'
        get '/fb_account_campaigns' => 'facebook#account_campaigns'
        post '/fb_ad_account' => 'facebook#ad_account'
        get '/graph_data' => 'facebook#graph_data'
        post '/all_campaigns' => 'campaigns#all_campaigns'
        post '/create_campaign' => 'facebook#add_campaigns'
        resources :facebook, only: [:index, :destroy, :update]
        resources :campaigns, only: [:index]
        resources :adsets, only: [:index]
      end

      get 'hub' => 'home#hub'
      # get 'business' => 'home#business'
      get 'profile' => 'home#profile'
      get 'location_management' => 'home#location_management'
      get 'campaign_intelligence/update' => 'home#campaign_intelligence'
      get 'affiliate_dashboard' => 'affiliate#dashboard'

      resources :mail_templates
      resources :logins

      # Referrals

      # resources :referrals, only: %i[index update] do
      #   collection do
      #     get :analytics
      #   end
      # end

      # Videos & Academy

      resources :videos
      get '/categories_list', to: 'videos#categories_list'
      get '/academy', to: 'videos#academy'

      # Create utm urls
      resources :custom_urls

      # Grader

      get :mobile_insights, to: 'grader_reports#mobile_insights'
      get :desktop_insights, to: 'grader_reports#desktop_insights'
      get :landing_page_info, to: 'grader_reports#landing_page_info'
      get :backlinks_info, to: 'grader_reports#backlinks_info'
      get :competitors_organic, to: 'grader_reports#competitors_organic'
      get :competitors_adwords, to: 'grader_reports#competitors_adwords'

      # Notifications
      resources :webpush_subscriptions
      resources :notifications, only: %i[view index] do
        member do
          get :view
        end
      end

      namespace :businesses do
        namespace :adwords do
          get :campaigns
          get :campaign_locations
          get :connect
          get :connect_account
          get :oauth2callback

          get :ppc_summary
          get :ppc_ads
          get :ppc_keywords
          get :ppc_queries
          get :display_ads
          get :display_summary
          get :video_ads
          get :video_summary

          put :disconnect
        end

        namespace :tags do
          post :untag_business_keyword
          post :tag_keywords
          get :keywords
          get :index
          put :update
          delete :destroy
          post :create
        end

        resources :site_audits do
          member do
            get :site_audit_ranking_metrics
            get :site_audit_backlink
            get :site_audit_seo_analytics
            get :leo_report_rows
            get :site_audit_issues_data
            post :site_audit_edit_content
          end
        end

        resources :intelligence, only: [] do
          member do
            get :contacts_per_day
            get :top_keywords
            get :new_contacts_by_source
            get :contacts_overview
            get :best_performing_ads
            get :all
          end
        end

        namespace :billing do
          get :current_plan
          get :fetch_cards
          post :subscribe
          post :update_card
          post :update_customer
          post :add_subscription_account
          post :cancel_downgrade
          post :subscribe_to_free
        end

        resources :callrail, only: [:create] do
          collection do
            get  :all_accounts
            get  :all_companies
          end
        end
      end

      namespace :subscription do
        resources :plans, except: %i[new edit] do
          collection do
            get :client_plans
            get :client_private_plans
          end
        end
        resources :coupons, except: %i[new edit update]
      end

      delete 'google_search_console/disconnect', to: 'google_search_console#disconnect'
      delete 'google_analytics/disconnect', to: 'google_analytics#disconnect'

      resources :locales, only: :index

      namespace :ad_reports do
        get 'google/businesses', to: 'google#businesses'
        get 'facebook/businesses', to: 'facebook#businesses'
        get 'google/get_report', to: 'google#get_report'
        get 'facebook/get_report', to: 'facebook#get_report'
        get 'facebook/agencies', to: 'facebook#agencies'
        get 'google/agencies', to: 'google#agencies'
      end


      get 'keyword_planner/callback', to: 'super_admin/integrations/keyword_planner#oauth2callback'
      get 'auth/hubspot/callback', to: 'super_admin/integrations/hubspot#callback'
      post 'twillio/webhook', to: 'incoming_messages#webhook'
    end
  end
end
