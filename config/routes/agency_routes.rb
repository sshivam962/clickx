module AgencyRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :agency, path: :a do
        resources :contractors do
          collection do
            get :checkout
            post :payment
            get :new_card
            post :create_card
          end
        end
        resources :chats, path: :messages do
          collection do
            get :chat_history
            post :unread_messages
            post :update_message_read_status
          end
        end
        resources :projects do
          collection do
            get :proposals
            get :select_seconday_skills
            post :send_message
            get :proposal_modal
            get :proposal_accepted
          end
          member do
            get :project_proposals
            get :project_details
          end
        end
        resources :cards, only: %i[create index new] do
          collection do
            post :set_default
          end
        end
        resources :packages, only: :index
        namespace :packages do
          get 'growth/:key', action: 'growth', as: :growth
          get 'jumpstart'
          get 'facebook_ads'
          get 'facebook_ecommerce_ads'
          get 'generate_lead_strategy'
          get 'web_dev_product'
          get 'linkedin_ads'
          get 'google_ads'
          get 'programmatic_and_geo_fencing'
          get 'seo_services'
          get 'funnel_development'
          get 'social_media'
          get 'digital_pr'
          get 'ala_carte'
          get 'local_seo'
          get 'custom_packages'
          get 'bundle', to: '/agency/bundle_packages#index'
        end

        post 'packages/set_web_develop', to: 'packages#set_web_develop'

        resources :payments, only: :index
        get :billing_history, to: 'package_subscriptions#index'

        get 'package_subscriptions/:id/invoices', to: 'package_subscriptions#invoices'
        get 'package_subscriptions/new_card', to: 'package_subscriptions#new_card'
        get 'package_subscriptions/new_business', to: 'package_subscriptions#new_business'
        post 'package_subscriptions/create_client', to: 'package_subscriptions#create_client'
        post 'package_subscriptions/create_card', to: 'package_subscriptions#create_card'
        get 'package_subscriptions/success'


        #Bundle checkout
        get 'checkout/bundle/:package', to: 'bundle_package_subscriptions#new', as: :bundle_checkout
        post 'checkout/bundle/:package', to: 'bundle_package_subscriptions#create', as: :bundle_subscribe_package

        get 'checkout/:package/:plan', to: 'package_subscriptions#new', as: :checkout
        post 'checkout/:package/:plan', to: 'package_subscriptions#create', as: :subscribe_package
        post 'package_subscriptions/upgrade/:package/:plan',
          to: 'package_subscriptions#upgrade',
          as: :package_subscription_upgrade
        post 'package_subscriptions/change_plan', to: 'package_subscriptions#change_plan', as: :change_plan

        post 'package_subscriptions/load_plan',
            to: 'package_subscriptions#load_plan',
            as: :load_plan

        resources :badges, only: :index
        resources :users, only: %i[index new edit update destroy] do
          member do
            put :resend_invitation
            post :set_agency_super_admin
            patch :set_agency_user_info
          end
        end

        get :support, to: 'support#index'
        post :support, to: 'support#create'

        get :community, to: 'community#index'

        resources :grader_reports, only: %i[index show create destroy] do
          member do
            get :mobile_insights
            get :desktop_insights
            get :landing_page_info
            get :backlinks_info
            get :competitors_organic
            get :competitors_adwords
            get :full_report
          end
        end

        resources :case_studies, only: %i[show new create edit update destroy] do
          member do
            post :favorite
          end
        end

        resources :external_leads, only: [] do
          collection do
            post 'data', to: "outscrapper#outscrapper_data"
            post 'advanced_data', to: "outscrapper#outscrapper_advanced_data"
            get 'data', to: 'outscrapper#index'
            get 'download_data/:outscrapper_request_id', to: 'outscrapper#download_data', as: :download_data
            patch 'reorder_data/:id', to: 'outscrapper#reorder_data', as: :reorder_data
          end
          member do
            post :upload_redymode_data, to: 'outscrapper#upload_redymode_data'
          end  
        end
        resources :case_study_images, only: [] do
          member do
            patch :update_position
          end
        end

        get 'industries/:industry_id/case_studies/:my_case_study', to: 'case_studies#index', as: :industry_case_study

        get :case_study_categories, to: 'case_studies#categories', as: :case_study_categories

        get 'case_study_categories/:category_id', to: 'case_studies#category_case_studies', as: :category_case_studies

        resources :documents do
          collection do
            get :search
            post :load_documents
            post :load_my_documents
          end
        end

        resources :portfolio do
          collection do
            post :load_portfolio
          end
        end

        resources :facebook_ads, only: %i[index show] do
        end

        resources :plug_and_play_ads, only: %i[index show] do
        end

        resources :social_posts, only: %i[index show]

        resources :value_hooks

        resource :challenge_offer, only: %i[show create] do
          collection do
            get :payment_details
          end
        end

        resources :lead_sources do
          get 'buy_data_requests', on: :collection
          delete 'delete_data_requests/:id', to: "lead_sources#delete_data_requests", as: :delete_data_requests, on: :collection
          get 'cities', on: :collection
          member do
            post :enable
            post :disable
            post :activate_autopilot
            post :autopilot_send_contacts
          end

          collection do
            get :search_outscrapper_categories
          end
        end

        resources :email_templates do
          member do
            post :create_duplicate_email_template
            post :disable_email_template
          end  
        end

        resources :direct_leads do
          member do
            post :preview_mail
            post :create_intro
            post :draft_mail
            get :list_contacts
            post :create_contact
            get :new_contact
            get :contacts
            post :change_lead_source
            post :add_to_negative_domains_list
            post :convert
            post :reject
          end
          collection do
            post :site_audit
            get :create_from_clickx
            post :import_from_d7
            post :import_from_csv
            get :emailed
            get :next_contact
          end
        end
        get '/direct_lead/:id/edit_contact/:contact_id',
            to: 'direct_leads#edit_contact',
            as: :edit_direct_lead_contact
        post '/direct_lead/:id/update_contact/:contact_id',
             to: 'direct_leads#update_contact',
             as: :update_direct_lead_contact
        delete '/direct_lead/:id/delete_contact/:contact_id',
               to: 'direct_leads#delete_contact',
               as: :delete_direct_lead_contact
        get :direct_lead, to: 'direct_leads#direct_lead',
                          as: :single_direct_lead

        resources :faqs, only: :index

        resources :industries, only: :index do
          member do
            post :favorite
            post :update_lead_form
          end
        end

        get 'roi', to: 'roi_calculator#index', as: :roi_calculator
        get 'roi_calculator', to: 'roi_calculator#show', as: :roi_calculator_show
        get 'roi_ecom_calculator', to: 'roi_calculator#roi_ecom_calculator', as: :roi_ecom_calculator

        get 'data_studio', to: 'data_studio#index', as: :data_studio

        get 'dev', to: 'dev#index', as: :dev
        # get 'facebook_ads', to: 'facebook_ads#index', as: :facebook_ads

        resources :menu_permissions, only: :index do
          collection do
            get :prospecting_lists
            get :prospecting_send
            get :prospecting_reports
            get :tools_portfolio
            get :tools_documents
            get :tools_social_posts
            get :tools_value_hooks
            get :tools_payments
            get :tools_roi
            get :tools_grader
            get :tools_casestudy
            get :tools_casestudy_show
            get :tools_data_studio
            get :project_myproject
            get :project_post
            get :project_proposals
            get :project_messages
            get :project_contractors
            get :plans
            get :academy

            get :scale_program_modules
            get :resource_scale
            get :scale_program_coaching
            get :affiliate_dashboard
            get :start_program_modules
            get :agency_infrastructure
            get :agency_website
            get :sales_coaching
            get :support
            get :faq
            get :community
          end
        end

        resources :courses, only: %i[show index] do
          member do
            post :load_chapter
            post :complete_chapter
            post :favorite
          end
        end

        resources :scale_program, only: %i[show index] do
          collection do
            get :documents
            get :recordings
            get :reverse_scale_calculator
          end
        end

        resources :start_agency_courses, only: %i[show index]
        resources :start_agency_coaching_courses, only: %i[show index]
        resources :fulfilment_courses, only: %i[show index]

        resource :complete_action_steps, only: %i[create destroy]

        get 'signup/dfy', to: 'signups#tyler', as: :tyler

        get 'signup/:tier/:referral_code', to: 'referrals#new', constraints: AgencySignupTierConstraint.new, as: :referral_signup
        resources :referrals, only: :create

        get 'signup/free/(:referral_code)', to: 'signups#free'
        post :free_signup, to: 'signups#free_signup'

        get 'signup/:tier', to: 'signups#paid', as: :paid, constraints: AgencySignupTierConstraint.new
        post 'signup/(:tier)', to: 'signups#create', as: :signup

        get :check_coupon, to: 'signups#check_coupon'

        resources :settings, only: :index do
          collection do
            patch :update
            get 'states'
            get 'branding'
            patch 'update_logo'
            patch 'verify_cname'
            resources :payments, only: :create, controller: 'settings/payments', as: :settings_payments
            patch :change_currency
          end
        end

        resource :profile, only: [:update, :show]

        resources :leads, except: :show do
          member do
            get :default_strategies
            get :strategies
            patch :unarchive
            delete :force_delete
          end

          collection do
            get :archived
          end

          resources :strategies, controller: 'lead/strategies', only: %i[new create update edit] do
            member do
              patch :archive
              patch :unarchive
              get :reorder_items
            end
          end

        end
        resources :strategy_items, controller: 'lead/strategy_items', path: 'lead/strategy_items', only: [] do
          member do
            get :load_item
          end
        end

        resources :agreements, only: %i[create]
        get :sign_agreement, to: 'agreements#new'
        get :agreement, to: 'agreements#show'
        get :download_agreement, to: 'agreements#download'

        resources :addendums, only: %i[create]
        get :sign_addendum, to: 'addendums#new'
        get :addendum, to: 'addendums#show'
        get :download_addendum, to: 'addendums#download'

        resources :client_questionnaires, only: :show,
                  controller: 'inquiry/client_questionnaires'

        resources :clients do
          member do
            get :questionnaires
            get :email_settings
            get :lead_info
            patch :add_keywords
          end
          resources :locations, only: %i[index update]
        end

        resources :funnel_pages do
          member do
            get :preview
          end
        end

        resources :stripe_credentials, only: :create
        get 'leads/:resource_id/payment_links/new', to: 'payment_links#new', defaults: {resource_type: 'Lead'}, as: :new_lead_payment_link
        get 'clients/:resource_id/payment_links/new', to: 'payment_links#new', defaults: {resource_type: 'Business'}, as: :new_client_payment_link

        resources :payment_links do
          member do
            patch :enable
            patch :disable
          end

          collection do
            get :resource_dropdown
            get :business_users_dropdown
            get :user_info
          end
        end

        resources :todo_lists do
          resources :todo_items do
            member do
              patch :update_status
              patch :update_position
            end
          end
        end

      end
    end
  end
end
