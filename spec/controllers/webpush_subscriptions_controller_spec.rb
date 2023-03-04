# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpushSubscriptionsController, type: :controller do
  login_company_admin
  describe 'POST #create' do
    it 'create subscription' do
      params = {
        message: 'test',
        subscription: {
          endpoint: 'http://jshfh.com',
          keys: {
            p256dh: 'sdfsdf',
            auth: 'dsfsdf'
          }
        }
      }

      expect { post :create, params: params }.to change { WebpushSubscription.count }
      expect(response).to have_http_status(:success)
    end
  end
end
