# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Businesses::Adwords', type: :request do
  include_context 'authenticated business user'

  describe 'GET /businesses/adwords' do
    it 'fetch campaigns from connected adword account' do
      get businesses_adwords_campaigns_path(id: business.id)
      expect(response).to have_http_status(200)
    end
  end

  describe 'disconnects adwords account' do
    context 'when type is valid or not specified' do
      before do
        create(:token, business: business)
      end
      it 'responds with success' do
        put businesses_adwords_disconnect_path(id: business.id)
        expect(response).to have_http_status :ok
      end
    end
    context 'when type is invalid' do
      it 'responds with not found' do
        put businesses_adwords_disconnect_path(id: business.id, type: 'test')
        expect(response).to have_http_status :not_found
      end
    end
  end
end
