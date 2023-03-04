# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  before do
    mock_geocoding!
  end

  it 'returns address' do
    loc = build(:location)
    addr = [loc.address, loc.city, loc.state, loc.country, loc.zip].compact.join(', ')
    expect(loc.loc_address).to eq(addr)
  end

  context 'json data' do
    it 'does not contain created_at' do
      loc = create(:location)
      data = loc.as_json
      expect(data.keys.include?(:created_at)).to eq(false)
    end

    it 'has custom values added in json' do
      loc = create(:location)
      data = loc.as_json
      expect(data.keys.include?(:created_at)).to eq(false)
      expect(data.keys.include?(:social_links)).to eq(true)
      expect(data.keys.include?(:local_profile_enabled)).to eq(true)
      expect(data.keys.include?(:updated_at)).to eq(true)
    end

    it 'contains selected fields when passed for_local_profile arg' do
      loc = create(:location)
      data = loc.as_json(for_local_profile: true)
      expect(data.keys.include?(:created_at)).to eq(false)

      expect(data.keys.include?('id')).to eq(true)
      expect(data.keys.include?('name')).to eq(true)
      expect(data.keys.include?('local_profile_list')).to eq(true)
      expect(data.keys.include?('address')).to eq(true)
      expect(data.keys.include?('city')).to eq(true)
      expect(data.keys.include?('state')).to eq(true)
      expect(data.keys.include?('country')).to eq(true)
      expect(data.keys.include?('zip')).to eq(true)
      expect(data.keys.include?('phone')).to eq(true)
      expect(data.keys.include?('lat')).to eq(true)
      expect(data.keys.include?('lng')).to eq(true)
      expect(data.keys.include?('website')).to eq(true)
    end
  end
end
