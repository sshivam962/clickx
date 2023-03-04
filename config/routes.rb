# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_WEB_USERNAME'] && password == ENV['SIDEKIQ_WEB_PASSWORD']
  end
  mount Sidekiq::Web => '/sidekiq'
  mount Ckeditor::Engine => '/ckeditor'
  mount StripeEvent::Engine, at: '/stripe-webhook'
  mount Magic::Link::Engine, at: '/'

  as :user do
    authenticated :user do
      root 'home#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  devise_for :users, controllers: {
    invitations: 'users/invitations',
    registrations: 'registrations',
    sessions: 'sessions',
    devise_authy: 'authy'
  },
  path_names: {
    verify_authy: '/verify-token',
    enable_authy: '/enable-two-factor',
    disable_authy: 'disable-two-factor',
    verify_authy_installation: '/verify-installation'
  }

  extend GeneralRoutes

  extend OldRoutes

  extend AdminRoutes
  extend AgencyRoutes
  extend PublicRoutes
  extend BusinessRoutes
  extend NetworkRoutes

  # Allow http options request
  match '*path', via: [:options], to: (lambda do |_|
    [
      204,
      {
        'Access-Control-Allow-Headers' => 'Origin, Content-Type, Accept, Authorization, Token',
        'Access-Control-Allow-Origin' => '*',
        'Content-Type' => 'text/plain'
      }, []
    ]
  end)
end
