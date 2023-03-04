# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Taggable, type: :model do
  it 'has a valid factory' do
    expect(create(:taggable)).to be_valid
  end

  it 'is invalid without a keyword' do
    expect(build(:taggable, keyword_id: nil, keyword_tag_id: 1)).not_to be_valid
  end

  it 'is invalid without a keyword_tag' do
    expect(build(:taggable, keyword_id: 1, keyword_tag_id: nil)).not_to be_valid
  end
end
