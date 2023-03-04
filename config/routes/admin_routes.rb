module AdminRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :super_admin, path: :s do
        get '/', to: 'dashboard#home'

        resources :workable_webhooks, ony: [:index, :create, :destroy]

        resources :contractors do
          member do
            patch :approve_user
          end
          collection do
            delete :remove_user
            get :users_lists
          end
        end

        resources :welcome_banners
        resources :chat_templates

        resources :contractors_invites do
          collection do
            post :send_email
          end
        end

        resources :blacklisted_domains, only: [:index, :create, :destroy]

        resources :mailgun_subdomains, only: [:index, :create, :destroy]

        resources :onboarding_checklists do
          collection do
            post :sort_position
          end
        end

        resources :onboarding_sections do
          collection do
            post :create_checklist
            post :update_checklist
            post :sort_position
            post :delete_checklist
          end
        end

        resources :chats, only: :index do
          collection do
            get :message_report
            post :import
            post :send_message
            get :get_chat_template
            post :create_ai_message
          end
          member do
            get :message_history
            post :reply
            post :block
          end
        end
        resources :privacy_policy
        resources :payment_links, only: %i[index new create edit update destroy] do
          member do
            get :clone
            patch :disabled
          end
        end
        resources :social_media_prompts, only: %i[index new create edit update destroy] do
          member do
            patch :disabled
            get :view
          end
          collection do
            post :create_ai_prompt
          end
        end
        resources :integrations, only: :index
        namespace :integrations do
          scope module: :keyword_planner, path: :keyword_planner, as: :keyword_planner do
            get :connect
            get :disconnect
            get :accounts
            post :connect_account
          end
          scope module: :hubspot, path: :hubspot, as: :hubspot do
            get :connect
            get :disconnect
          end
        end
        resources :content_settings
        resources :content_orders, only: :show do
          member do
            get :place_order_admin
          end
        end
        get '/:id/histories', to: 'businesses#show'
        resources :mail_templates, only: %i[index edit update]
        resources :mails
        resources :billing, only:[:index]
        resources :plans
        resources :coupons
        resources :groups
        resources :questions do
          member do
            patch :move_position
          end
        end
        resources :labels, only: %i[index] do
          collection do
            post :update
          end
        end
        resources :clients do
          member do
            get :questionnaires
            patch :unarchive
            delete :force_delete
            patch :update_home_link
            get :clear_yext_cache
            patch :update_customer
            patch :add_subscription_account
            get :activities
            post :disconnect_semrush_project
            post :connect_semrush_project
          end
          collection do
            get :client_sheet
            get :archived
            delete :remove_user
            get :traction
          end
        end

        resources :email_sents, only: :index

        resources :locations, only: :update do
          member do
            get :export_csv
          end

          collection do
            get :map
          end
        end

        resources :case_studies do
          member do
            post :set_assignee
            get :published
            get :preview
          end
        end
        resources :case_study_images, only: [] do
          member do
            patch :update_position
          end
        end
        resources :industries
        resources :documents
        resources :admin_documents

        resources :portfolio do
          member do
            get :preview
          end
        end

        resources :facebook_ads do
          member do
            get :preview
          end
        end

        resources :external_leads, controller: :outscrapper, only: %i[index show] do
          get 'list_name', on: :collection
          collection do
            get 'bulk_upload'
            post 'create_bulk_upload'
            post 'copy_data/:data_id', to: "outscrapper#copy_data", as: :copy_data
            get 'categories'
            post 'create_categories'
            delete 'destroy_category'
          end
        end

        resources :social_posts do
          member do
            get :preview
          end
        end

        resources :value_hooks

        resources :plug_and_play_ads do
          member do
            get :preview
          end
        end

        resources :faqs do
          member do
            post :sort
          end
        end
        resources :images, only: :destroy
        resources :custom_packages, except: %i[edit show] do
          collection do
            get 'load_businesses'
          end
        end
        post '/portfolio/sort', to: 'portfolio#sort', as: :sort_portfolio

        resources :agency_niches_access, only: [] do
          member do
            get :niches_list
            get :niches_access
            post :give_access
            delete :cancel_access
          end
        end

        resources :agencies do
          collection do
            get :agency_sheet
          end
          member do
            get :profile
            get :download
            patch :unarchive
            delete :force_delete
            patch :approve_signup
            get :scale_zoom
            patch :update_scale_zoom_weeks
          end
          collection do
            get :archived
            get :demo_agency
            get :verified_domains
          end
          member do
            get :agency_admins
            get 'agency_admins/invite', as: :invite_agency_admin, action: :invite_admin
            patch :update_home_link
            get :manage_growth_subscription
            patch :downgrade_plan
            get :change_agency_status
          end
        end

        resources :partner_search, only: %i[index]

        resources :users, only: %i[destroy edit update] do
          member do
            post :set_agency_super_admin
            post :set_email_alert
            put :resend_invitation
          end
        end

        resources :admin_faq, only: %i[index]

        resources :admin_manage_faqs do
          member do
            post :sort
          end
        end

        resources :admin_users, only: %i[index update destroy new] do
          collection do
            get :archived
          end
          member do
            patch :unarchive
            delete :force_delete
          end
        end
        get ':resource_type/courses', to: 'courses#index', as: :list_courses
        get ':resource_type/courses/new', to: 'courses#new', as: :new_course
        get :scale_program, to: 'courses#scale_program', as: :scale_program

        resources :admin_courses, only: %i[index show] do
          member do
            post :load_chapter
            post :complete_chapter
          end
        end

        resources :scale_program_headers

        resources :course_challenges

        resources :start_agency_courses

        resources :fulfilment_courses

        resources :courses, except: %i[index new] do
          member do
            post :create_action_step
            delete :destroy_action_step
            patch :move_up
            patch :move_down
            post :load_chapter
            patch :update_position
          end
          collection do
            post :department_wise_user
          end
          resources :chapters, except: :index do
            member do
              patch :update_position
            end
          end
        end

        resources :leads, only: %i[index show edit update] do
          member do
            get :info
            patch :old_strategy
          end
          collection do
            post :export_csv
          end
          resources :strategies, controller: 'lead/strategies' do
            member do
              patch :approve
              patch :send_approval
              get :carousel_preview
              get :preview
              get :reorder_items
            end
          end
        end
        resources :strategy_funnels, controller: 'lead/strategy_funnels', path: 'lead/strategy_funnels', only: %i[index create update destroy] do
          member do
            patch :move_position
          end
        end
        resources :strategy_items, controller: 'lead/strategy_items', path: 'lead/strategy_items' do
          member do
            get :favorite
            get :load_item
          end
        end
        get 'lead/strategies', to: 'lead/strategies#list_leads', as: :strategy_leads
        resources :packages, only: %i[index edit update] do
          collection do
            get ':key/preview', action: :preview, as: :preview
          end
          member do
            get :checklist
            delete :destroy_ensure_checklist
          end
        end
        resources :agency_signup_links,
                  only: %i[index create destroy new update edit] do
                    collection do
                      post :set_calendly
                      get :calendly_script
                      get :edit_admin_calendly_script
                      patch :update_admin_calendly_script
                      delete :delete_admin_calendly_script
                      get :new_admin_calendly_script
                      post :create_admin_calendly_script
                      get :set_calendly_script
                    end
                  end
        resources :business_signup_links,
                  only: %i[index create destroy new update edit]

        get ':category/package_subscriptions', to: 'package_subscriptions#index'
        resources :package_subscriptions, only: [] do
          member do
            get :more_info
            get :load_home_link
            get :new_op
            post :assign_op
            patch :update_op
            get :list_op
            post :cancel
            post :revert_cancel
          end
        end

        resources :subscription_schedules, only: [] do
          member do
            post :cancel
          end
        end

        namespace :inquiry do
          resources :questions
          resources :questionnaires
          resources :linked_questions do
            member do
              patch :change_position
            end
          end
        end

        resources :agency_settings, only: :index do
          collection do
            patch :update
          end
        end

        resources :onboarding_procedures, as: :procedures
        resources :reports, only: :index do
          member do
            get :change_keyword_ranking
            get :keywords_export
            delete :archive_client
          end
          collection do
            get :client
            get :google_ads
            get :google_clients
            get :facebook_ads
            get :facebook_clients
          end
        end
        resources :funnel_pages do
          member do
            get :preview
          end
        end
        resources :permissions, only: %i[index show destroy]
      end
    end
  end
end
