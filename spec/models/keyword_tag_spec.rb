# frozen_string_literal: true
require 'rails_helper'

RSpec.describe KeywordTag, type: :model do
  it 'has a valid factory' do
    expect(create(:keyword_tag)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:keyword_tag, name: nil, color: '#fffggg')).not_to be_valid
  end

  it 'is invalid without a color' do
    expect(build(:keyword_tag, name: 'Sample', color: nil)).not_to be_valid
  end
end
