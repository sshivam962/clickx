# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agency, type: :model do
  it 'is invalid without name' do
    expect(build(:agency, name: nil)).not_to be_valid
  end
  it 'is valid with name' do
    expect(build(:agency)).to be_valid
  end
  it 'json data should not contain created_at & updated_at' do
    2.times do
      create(:agency)
    end
    agencies = Agency.all.as_json
    json_keys = []
    agencies.each do |dt|
      json_keys << dt.keys
    end
    json_keys = json_keys.flatten.compact.uniq
    %w[name logo phone support_email address id].each do |fld|
      expect(json_keys.include?(fld)).to be true
    end
    %w[created_at updated_at].each do |fld|
      expect(json_keys.include?(fld)).to be false
    end
  end
end
