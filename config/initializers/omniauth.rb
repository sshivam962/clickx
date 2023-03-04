# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
           ENV['CLICKX_FB_APP_ID'], ENV['CLICKX_FB_APP_SECRET'],
           scope: 'email, ads_management, ads_read, business_management, leads_retrieval',
           display: 'popup', provider_ignores_state: true

  provider :google_oauth2,
           ENV['CLICKX_GOOGLE_APP_ID'], ENV['CLICKX_GOOGLE_APP_SECRET'],
           scope: 'plus.login, userinfo.email, userinfo.profile, plus.me',
           provider_ignores_state: true
end
OmniAuth.config.full_host = ROOT_URL

# Moneky patch omniauth oauth2 for white labelling support
module OmniAuth
  module Strategies
    class OAuth2
      def authorize_params
        options.authorize_params[:state] = SecureRandom.hex(24)
        params = options.authorize_params.merge(options_for('authorize'))
        if OmniAuth.config.test_mode
          @env ||= {}
          @env['rack.session'] ||= {}
        end
        session['omniauth.state'] = params[:state]
        Rails.cache.write(params[:state], { domain: Thread.current['Clickx-FullDomain'] }, expires_in: 5.minutes)
        params
      end
    end
  end
end
