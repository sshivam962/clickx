# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  login_company_admin

  let(:notification) { create(:notification) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #view' do
    it 'returns http success' do
      get :view, params: { id: notification.id }
      expect(response).to have_http_status(:found)
    end
  end
end
