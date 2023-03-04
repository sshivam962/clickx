# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    User.destroy_all
    BusinessesUser.destroy_all
    Business.destroy_all
  end
  it 'is invalid without first_name' do
    expect(build(:user, first_name: nil)).not_to be_valid
  end
  it 'is valid without last_name' do
    expect(build(:user, last_name: nil)).to be_valid
  end

  it 'associates unique_id when created' do
    user = build(:user)
    expect(user.unique_id.nil?).to eq(true)
    user.save
    expect(user.unique_id.nil?).to eq(false)
  end

  it 'checks for role' do
    admin = build(:super_admin)
    company_admin = build(:company_admin)
    company_user = build(:user)

    expect(admin.super_admin?).to eq(true)
    expect(admin.company_admin?).to eq(false)
    expect(admin.company_user?).to eq(false)

    expect(company_admin.super_admin?).to eq(false)
    expect(company_admin.company_admin?).to eq(true)
    expect(company_admin.company_user?).to eq(false)

    expect(company_user.super_admin?).to eq(false)
    expect(company_user.company_admin?).to eq(false)
    expect(company_user.company_user?).to eq(true)
  end

  it 'returns complete name' do
    user = build(:user)
    expect(user.name).to eq("#{user.first_name} #{user.last_name}")
  end

  xit 'json data fields' do
    user = create(:user)
    json_data = user.as_json
    expect(json_data.keys.include?('first_name')).to eq(true)
    expect(json_data.keys.include?('last_name')).to eq(true)
    expect(json_data.keys.include?('id')).to eq(true)
    expect(json_data.keys.include?('role')).to eq(true)
    expect(json_data.keys.include?('invitation_sent_at')).to eq(true)
    expect(json_data.keys.include?('invitation_accepted_at')).to eq(true)
    expect(json_data.keys.include?('email')).to eq(true)
    expect(json_data.keys.include?('sign_in_count')).to eq(true)
    expect(json_data.keys.include?('password')).to eq(false)
    expect(json_data.keys.include?('invitation_token')).to eq(false)
  end

  it 'associates business with user' do
    expect(BusinessesUser.count).to eq(0)
    biz = create(:business)
    expect(BusinessesUser.count).to eq(1)
    user = build(:user)
    user.ownable = biz
    user.save
    expect(BusinessesUser.count).to eq(2)
  end

  it 'is able to find user either by email when signing in' do
    user = create(:user)

    signin_user = User.find_for_database_authentication(login: user.email)
    expect(signin_user).to eq(user)
    user = User.find_for_database_authentication(login: user.email)
    expect(signin_user).to eq(user)

    user = User.find_for_database_authentication(email: user.email)
    expect(signin_user).to eq(user)
  end

  context 'header id for display' do
    it 'returns admin users unique id' do
      biz = create(:business)
      user = create(:super_admin)
      expect(user.header_customer_id(biz.unique_id)).to eq(user.unique_id)
    end

    it 'returns admin users unique id' do
      biz = create(:business)
      user = create(:user)
      expect(user.header_customer_id(biz.unique_id)).to eq("#{biz.unique_id} - #{user.unique_id}")
    end
  end

  context '.with_agency_admin_email_preference' do
    let(:agency) { create(:agency) }
    let(:business) { create(:business, agency: agency) }
    let(:agency_admin1) { create(:agency_admin, ownable: agency) }
    let(:agency_admin2) { create(:agency_admin, ownable: agency) }

    context 'Default email preference' do
      it 'Empty by default' do
        expect(User.with_agency_admin_email_preference(:reviews, :review_updates, true)).to be_empty
      end

      it 'lists users with enabled email preference' do
        agency_admin1 = create(:agency_admin, ownable: agency)
        agency_admin2 = create(:agency_admin, ownable: agency)
        agency_admin_business_email_preference = create(:agency_admin_business_email_preference, business: business, user: agency_admin2)
        email_preference = create(:email_preference,
                                  feature: :reviews,
                                  key: :review_updates,
                                  enabled: true,
                                  ownable: agency_admin_business_email_preference)
        expect(User.with_agency_admin_email_preference(:reviews, :review_updates, true)).to match_array([agency_admin2])
      end
    end
    context '.with_user_email_preference' do
      it 'list users' do
        business_admin = create(:company_admin, ownable: business)
        business_email_preference = create(:email_preference,
                                           feature: :reviews,
                                           key: :review_updates,
                                           enabled: true,
                                           ownable: business_admin)
        expect(User.with_user_email_preference(:reviews, :review_updates, true)).to match_array([business_admin])
      end
    end
  end
end
