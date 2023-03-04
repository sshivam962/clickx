# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdwordsMailer, type: :mailer do
  describe 'disconnect_account' do
    let(:business) { create(:business) }
    let(:mail) { AdwordsMailer.disconnect_account(business, 'adword') }

    before do
      @user = create(:company_admin, ownable: business)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Ads account disconnected')
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(['support@clickx.io'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Adwords')
    end
  end
end
