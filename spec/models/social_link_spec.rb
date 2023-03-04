# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SocialLink, type: :model do
  it 'json data should not contain created_at & updated_at' do
    social_link = build(:social_link)
    json_data = social_link.as_json
    expect(json_data.keys.include?(:created_at)).to eq(false)
    expect(json_data.keys.include?(:updated_at)).to eq(false)
  end
end
