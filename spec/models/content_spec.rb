# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, type: :model do
  it 'has a valid factory' do
    expect(create(:content)).to be_valid
  end

  it 'is invalid without a title' do
    expect(build(:content, title: nil)).not_to be_valid
  end

  it 'has state as draft on create' do
    @foo = create(:content)
    expect(@foo.state).to eq('draft')
  end

  context 'without state' do
    before do
      @foo = create(:content)
      @foo.state = nil
    end

    it 'is invalid after create if state in nil' do
      expect(@foo.valid?).to eq(false)
    end

    it 'shows error message' do
      expect(@foo).not_to be_valid
      expect(@foo.errors.messages[:state].last).to eq('not a valid state')
    end

    it 'is invalid if state not amongst the ContentStates' do
      @foo.state = 'false_state'
      expect(@foo).not_to be_valid
    end
  end

  it 'gives all the comments associated with content' do
    @foo = create(:content_with_comments)
    expect(@foo.get_comments.length).to eq(@foo.comments.length)
  end

  it 'json data should include comments as well' do
    @foo = create(:content_with_comments)
    contents = @foo.as_json(for_view: true)
    json_keys = contents.keys
    json_keys = json_keys.flatten.compact.uniq
    %w[title link state meta_description meta_title content created_at updated_at].each do |elements|
      expect(json_keys.include?(elements)).to be true
    end

    # includes get_comments
    expect(json_keys.include?(:get_comments)).to be true
  end
end
