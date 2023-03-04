# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/failed_keyword_ranks')

describe FailedKeywordRanks do
  class DummyClass
  end

  include described_class

  before do
    @dummy_class = DummyClass.new
    @dummy_class.extend(described_class)
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      host: 'localhost',
      database: 'clickx_test',
      username: 'postgres',
      password: 'postgres'
    )
  end

  xit 'should contain a keys' do
    fns = described_class.methods
    expect(fns.include?(:get_failed_rank)).to eq true
    keys = %w[name city biz_name biz_id]
    expect((described_class.get_failed_rank[0].keys & keys).any?).to eq true
  end
end
