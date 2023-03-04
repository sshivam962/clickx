# frozen_string_literal: true

shared_context 'authenticated business user' do
  let(:business) { create(:business) }
  let(:business_user) { create(:company_admin, ownable: business) }

  before do
    sign_in business_user
  end
end
