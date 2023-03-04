module BusinessRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :business, path: :b do
        get :dashboard, to: 'dashboard#show'

        namespace :google_ads do
          get :connect
          get :oauth2callback
          put :disconnect

          get :select_accounts
          post :update_customer_id
          post :update_connected_campaigns

          get :/, action: :summary
          get :summary
          get :keywords
          get :ads
          get :search_terms
          get :campaigns
        end

        namespace :facebook_ads do
          get :/, action: :campaigns
          get :campaigns
          get :adsets
          get :ads
          get :ad_preview
        end

        namespace :google_analytics do
          get :/, action: :overview
          get :overview
          get :overview_charts
          get :keywords
          get :top_pages
          get :referrals
          get :locales
          get :campaigns
          get :source_medium
        end

        namespace :search_console do
          get :/, action: :overview
          get :top_pages
          get :sitemaps
          get :download_csv
        end

        namespace :dashboard do
          get :search_ads
          get :facebook_ads
          get :display_ads
          get :youtube_ads
          get :google_analytics
          get :google_search_console
        end

        namespace :packages do
          get :facebook_ads
          get :google_ads
          get :seo_services
          get :funnel_development
          get :social_media
          get :digital_pr
          get :ala_carte
          get :local_seo
          get :custom_packages
        end

        resources :reviews, only: [:index, :destroy]
        resources :locations do
          resources :reviews, only: :index, module: :locations do
            collection do
              get :site
              get :ratings
              get 'directory/:dir', to: "reviews#dir_reviews"
              get :reviews_with_star
              post :send_mail_with_id
              post :send_mail
            end
          end
        end

        resources :keywords, only: [:index, :create, :new] do
          collection do
            get 'keyword_suggestions'
          end
        end

        resources :keywords_generator, only: %i[index create] do
          collection do
            post :generate
            get :keyword_suggestions
          end
        end

        resources :callrail do
          collection do
            get :recording
            get :data
          end
        end

        resources :custom_urls

        resources :courses, only: %i[show index] do
          member do
            post :load_chapter
            post :complete_chapter
          end
        end

        resources :agreements, only: %i[create]
        get :sign_agreement, to: 'agreements#new'
        get :agreement, to: 'agreements#show'
        get :download_agreement, to: 'agreements#download'

        # get 'competition/:id', to: 'competitions#show', as: :show_client_competition
        resources :competitions, as: :client_competitions do
          collection do
            get :export_csv
            get :export_pdf
            get :potential_competitors
            get :common_backlinks
            get :export_top_pages_csv
            get :export_keywords_organic_csv
            get :export_keywords_paid_csv
            get :export_backlinks_csv
            get :export_anchor_texts_csv
          end
          member do
            delete :destroy
            get :organic_keywords
            get :paid_keywords
            get :fresh_backlinks
            get :all_backlinks
            get :anchor_text
            get :competitors_rank
            post :add_keyword
            post :remove_keyword
          end
        end

        resources :backlinks, only: :index do
          collection do
            get :all
            get :anchor_text
            get :topics
            get :pages
            get :referring_domains
          end
        end

        resources :support, only: :index
        resources :users, only: %i[index new destroy] do
          member do
            put :resend_invitation
          end
        end

        resources :settings do
          collection do
            get :general
            get :budget_pacing
            get :content_ordering
            get :email_notifications
            patch :update_logo
            patch :update_business
            patch :set_budget
            patch :set_default_content_order
            patch :update_mailing_list
          end
          member do
            delete :remove_card
          end
        end

        get 'package_subscriptions/new_card', to: 'package_subscriptions#new_card'
        get 'package_subscriptions/success'
        get 'checkout/:package/:plan',
            to: 'package_subscriptions#new',
            as: :checkout
        post 'checkout/:package/:plan',
            to: 'package_subscriptions#create',
            as: :subscribe_package

        post 'package_subscriptions/create_card',
            to: 'package_subscriptions#create_card'

        resources :call_analytics, only: :index do
          member do
            get 'show_call_details'
          end
        end
      end

      namespace :business, path: :smb do
        get 'signup/:tier', to: 'signups#paid', as: :paid,
                            constraints: BusinessSignupTierConstraint.new
        post 'signup/(:tier)', to: 'signups#create', as: :signup
        get :check_coupon, to: 'signups#check_coupon'
      end
    end
  end
end
