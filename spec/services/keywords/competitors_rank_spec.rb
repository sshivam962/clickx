# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Keywords::CompetitorsRank do
  let(:business) { create(:business) }

  it '#fetch' do
    @competition = create(:competition, business: business)
    @keyword = create(:keyword, business: business)
    expect(described_class.new(@keyword.name, business).fetch).to be_truthy
  end
end
