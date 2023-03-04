# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tokens', type: :request do
  let(:business) do
    create(:business, fb_access_token: 'token', fb_access_secret: 'secret')
  end
  let(:user) { create(:user) }
  let(:token) { 'new_token' }
  let(:secret) { 'new_secret' }

  before do
    sign_in user
  end

  describe '#facebook_oauth_callback' do
    before do
      allow_any_instance_of(TokensController).to receive(:current_business)
        .and_return(business)
      allow_any_instance_of(TokensController).to receive(:fetch_long_term_token)
        .and_return(token)
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '123456',
        credentials: {
          token: business.fb_access_token,
          secret: secret
        }
      )
    end

    it 'updates business access_token with new access token' do
      get '/auth/facebook/callback'
      expect(business.fb_access_token).to eq token
      expect(business.fb_access_secret).to eq secret
    end

    it 'redirects to business social media page' do
      get '/auth/facebook/callback'
      expect(response).to redirect_to(root_url + "#/social")
    end

    context 'when feature is facebook_ads' do
      it 'redirects to business facebook ads page' do
        get '/auth/facebook/callback', params: { feature: 'facebook_ads' }
        expect(response).to redirect_to(root_url + "b/facebook_ads")
      end
    end

    context 'when redirect_to option is specified as integrations' do
      before do
        allow_any_instance_of(TokensController).to receive(:redirect_to_option)
          .and_return('integrations')
      end

      it 'redirects to integrations page' do
        get '/auth/facebook/callback'
        expect(response).to redirect_to(root_url + '#/integrations')
      end
    end
  end
end
