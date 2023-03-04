module PublicRoutes
  def self.extended(router)
    router.instance_exec do
      scope module: :public do
        match '/:agency_slug/register-lead',
          to: 'leads#create',
          as: :register_lead,
          via: %i[get post]

        get 'contractors_invite/unsubscribe/:encrypted_email',
            to: 'contractors_invite#unsubscribe',
            as: :unsubscribe_contractor

        get '/:agency_slug/roi-calculator', to: 'roi_calculator#index', as: :public_roi_calculator, constraints: ROMICalculatorConstraint.new
        post 'free-email-validator', to: 'email_checker#check'

        get 'pc/:id/reviews', to: 'clients#reviews', as: :business_reviews
        get 'pc/:id/map', to: 'clients#map'
        get 'pc/:id/map_info', to: 'clients#map_info'
        get 'pl/:id/reviews', to: 'locations#reviews', as: :location_reviews

        get 'fp/:agency_id/:id/privacy', to: 'privacy_policy#index', as: :public_privacy_policy

        post 'workable/callback', to: 'workable_webhooks#callback', as: :workable_webhooks_callback
        post 'freshteam/callback', to: 'freshteam_webhooks#callback', as: :freshteam_webhooks_callback

        post 'sendgrid/webhook', to: 'sendgrid_events#callback'
        post 'outscraper/callback', to: 'outscraper_webhooks#callback'

        get 'p/states', to: 'states#list', as: :states
        get 'p/cities', to: 'cities#list', as: :cities
        resources :grader, only: :show, controller: :grader_reports, path: :g, constraints: GraderAppConstraint.new do
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
        resources :questionnaires, only: %i[update show], path: :q,
                  as: :client_questionnaires,
                  controller: 'inquiry/client_questionnaires',
                  constraints: ClientQuestionnaireConstraint.new

        get 'mailing/unsubscribe/:encrypted_email',
          to: 'domain_contacts#unsubscribe',
          as: :unsubscribe

        get 'cs/:agency_id/:id', to: 'case_studies#show', as: :case_studies, constraints: AgencyCaseStudyConstraint.new

        get 'ls/:id/carousel', to: 'lead/strategies#carousel', as: :lead_strategy_carousel, constraints: LeadStrategyConstraint.new
        get 'ls/:id', to: 'lead/strategies#show', as: :lead_strategy, constraints: LeadStrategyConstraint.new
        get 'ls/:category/:lead_id', to: 'lead/strategies#default', as: :default_lead_strategy, constraints: GrowthStrategyConstraint.new

        # resources :contact_us, only: :create

        get 'pf/:agency_id/:id', to: 'portfolios#show', as: :public_portfolio, constraints: AgencyPortfolioConstraint.new
        get 'fb_ads/:agency_id/:id', to: 'facebook_ads#show', as: :public_facebook_ads, constraints: AgencyPortfolioConstraint.new
        get 'pp_ads/:agency_id/:id', to: 'plug_and_play_ads#show', as: :public_plug_and_play_ads, constraints: AgencyPortfolioConstraint.new
        get 'pvh/:agency_id/:id', to: 'value_hooks#show', as: :public_value_hooks, constraints: AgencyPortfolioConstraint.new

        get 'fp/:agency_id/:id', to: 'funnel_pages#show', as: :funnel_pages, constraints: FunnelPageConstraint.new
        post 'fp/create_lead', to: 'funnel_pages#create_lead', as: :create_lead_funnel_pages, constraints: FunnelPageConstraint.new

        get 'start-service/:id', to: 'payment_links#show', as: :start_service_payment_links, constraints: PaymentLinkConstraint.new
        post 'start-service/:id', to: 'payment_links#subscribe', as: :subscribe_payment_links, constraints: PaymentLinkConstraint.new
        post 'payment_links/create_card', to: 'payment_links#create_card', as: :create_card_payment_links, constraints: PaymentLinkConstraint.new

        get 'start-payment/:id', to: 'admin_payment_links#show', as: :public_admin_payment_link, constraints: PaymentLinkConstraint.new
        post 'start-payment/:id', to: 'admin_payment_links#subscribe', as: :subscribe_admin_payment_links, constraints: PaymentLinkConstraint.new
        post 'admin_payment_links/create_card', to: 'admin_payment_links#create_card', as: :create_card_admin_payment_links, constraints: PaymentLinkConstraint.new

        post 'pu/check_email', to: 'users#check_email', as: :check_email
      end
    end
  end
end
