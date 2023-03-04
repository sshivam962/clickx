# frozen_string_literal: true

require 'rails_helper'

describe 'reviews:send_daily_email' do
  include_context 'rake'
  it 'sends mail' do
    mock_geocoding!
    business = create(:business)
    location = create(:location, business: business)
    create(:review, location: location)

    business_admin = create(:company_admin, ownable: business)
    business_email_preference = create(:email_preference,
                                       feature: :reviews,
                                       key: :review_updates,
                                       enabled: true,
                                       ownable: business_admin)

    expect(Notifier).to receive(:new_reviews_email).and_return(double(:mailer, deliver_later: true))
    subject.invoke
  end
end
