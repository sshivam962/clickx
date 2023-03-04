# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DomainRanking, type: :model do
  it 'returns domain ranking object' do
    rank = DomainRanking.first_or_dup_on(keyword_name: 'example', domain: 'example.com')
    expect(rank.keyword_name).to eq('example')
  end
end
