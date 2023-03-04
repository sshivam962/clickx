# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpushSubscription, type: :model do
  it 'has valid factory' do
    expect(build(:webpush_subscription)).to be_valid
  end
end
