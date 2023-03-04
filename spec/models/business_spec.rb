# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business, type: :model do
  it 'is invalid without name' do
    expect(build(:business, name: nil)).not_to be_valid
  end
  it 'is valid with name' do
    expect(build(:business)).to be_valid
  end

  # trial service
  it 'is invalid with trial_service true & no trial_expiry_date' do
    expect(build(:business, trial_expiry_date: nil, trial_service: true)).not_to be_valid
  end
  it 'is valid with trial_service true & trial_expiry_date' do
    expect(build(:business, trial_expiry_date: Date.today + 10.days, trial_service: true)).to be_valid
  end

  context 'after create' do
    it 'assigns unique_id' do
      biz = build(:business)
      expect(biz.unique_id).to eq(nil)
      expect(biz.new_record?).to eq(true)
      biz.save
      expect(biz.new_record?).to eq(false)
      expect(biz.unique_id).not_to eq(nil)
    end

    it 'assigns system user' do
      biz = create(:business)
      expect(biz.users.count).to eq(1)

      user = biz.preview_users.first
      expect(user.role).to eq(User::CompanyAdmin)
    end

    it 'creates system user' do
      biz = create(:business)
      expect(biz.users.count).to eq(1)
      biz.users.first.destroy

      user = biz.create_clickx_user
      expect(biz.users.count).to eq(1)
      expect(user.preview_user).to eq(true)
      expect(user.role).to eq(User::CompanyAdmin)
      email = "#{biz.id}.#{biz.unique_id}@clickx.io"
      expect(user.email).to eq(email)
    end
  end

  context 'trial period' do
    before do
      @dt = Date.current + 3.days
      @biz = build(:business, trial_service: true, trial_expiry_date: @dt)
    end

    it 'returns remaining days' do
      @biz.trial_service = false
      expect(@biz.remaining_days).to eq(nil)
      @biz.trial_service = true
      expect(@biz.remaining_days).to eq(@dt - Date.current)
    end

    it 'returns boolean value on checking trial_expired?' do
      @biz.trial_service = true
      expect(@biz.trial_expired?).to eq(false)
      @biz.trial_expiry_date = Date.today - 2.days
      expect(@biz.trial_expired?).to eq(true)
    end

    it 'returns name for drop down of campaigns as per status of expiry period' do
      @biz.trial_service = false
      expect(@biz.expired_name).to eq(@biz.name)
      @biz.trial_service = true
      expect(@biz.expired_name).to eq(@biz.name.to_s)
      @biz.trial_expiry_date = Date.today - 2.days
      expect(@biz.expired_name).to eq("#{@biz.name} (Expired)")
    end
  end
  context 'json data' do
    before do
      3.times do
        create(:business)
      end
      @businesses = Business.all
    end

    def get_json_businesses(data)
      json_keys = []
      data.each do |biz|
        json_keys << biz.keys
      end
      json_keys.flatten.compact.uniq
    end

    it 'does not contain created_at' do
      data = @businesses.as_json
      json_keys = get_json_businesses(data)
      expect(json_keys.include?('created_at')).to eq(false)
    end

    it 'contains expired name if fetched for pop up list' do
      data = @businesses.as_json(popup_list: true)
      json_keys = get_json_businesses(data)
      expect(json_keys.include?('expired_name')).to eq(true)
    end

    it 'does not contain expired name if fetched for pop up list' do
      data = @businesses.as_json
      json_keys = get_json_businesses(data)
      expect(json_keys.include?('expired_name')).to eq(false)
    end

    it 'contains users in it' do
      data = @businesses.as_json
      json_keys = get_json_businesses(data)
      expect(json_keys.include?('name')).to eq(true)
    end
  end

  context '#backlinks_to_competitors' do
    let(:business) { create(:business) }

    it 'returns empty array when no common links available' do
      create(:competition, business: business)
      expect(business.backlinks_to_competitors).to be_empty
    end

    it 'returns single links' do
      backlinks = [
        {
          "SourceURL": 'http://aboobacker.in'
        }
      ]
      create(:competition, business: business, backlinks: backlinks)
      expect(business.backlinks_to_competitors).not_to be_empty
      expect(business.backlinks_to_competitors.first['count']).to eq 1
    end
  end

  context '#frequent_organic_keywords_among_competitors' do
    let(:business) { create(:business) }

    it 'returns empty array when no common keywords available' do
      create(:competition, business: business)
      expect(business.frequent_organic_keywords_among_competitors.to_a).to be_empty
    end
  end

  context 'Domain validation' do
    it 'valid with proper domain' do
      business = build_stubbed(:business, domain: 'https://clickx.io')
      expect(business).to be_valid
    end

    it 'valid without http(s) prefix' do
      business = build_stubbed(:business, domain: 'https://clickx.io')
      expect(business).to be_valid
    end

    it 'validate duplicate domains' do
      create(:business, domain: 'https://clickx.io')
      business = build_stubbed(:business, domain: 'https://clickx.io')
      expect(business).to be_invalid
    end

    xit 'treat domain as without http prefix' do
      create(:business, domain: 'http://clickx.io')
      business = build_stubbed(:business, domain: 'clickx.io')
      expect(business).to be_invalid
    end

    it 'treat domain without www same as domain without subdomain' do
      create(:business, domain: 'thimothy.com')
      business = build_stubbed(:business, domain: 'www.thimothy.com')
      expect(business).to be_invalid
    end
  end

  context '#users_with_email_preference' do
    let(:agency) { create(:agency) }
    let(:business) { create(:business, agency: agency) }

    context 'with default email preferences' do
      it 'list users with given email preferences' do
        agency_admin1 = create(:agency_admin, ownable: agency)

        business_admin = create(:company_admin, ownable: business)
        agency_admin_business_email_preference = create(
          :agency_admin_business_email_preference,
          business: business,
          user: agency_admin1
        )
        create(
          :email_preference,
          feature: :reviews,
          key: :review_updates,
          enabled: true,
          ownable: agency_admin_business_email_preference
        )

        create(
          :email_preference,
          feature: :reviews,
          key: :review_updates,
          enabled: true,
          ownable: business_admin
        )
        expect(business.users_with_email_preference(:reviews, :review_updates)).to match_array([agency_admin1, business_admin])
      end
    end
  end
end
