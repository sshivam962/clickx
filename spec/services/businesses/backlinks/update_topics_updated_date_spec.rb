# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Businesses::Backlinks::UpdateTopicsUpdatedDate do
  subject(:data) { described_class.new(business).call }

  let(:business) { build(:business) }

  describe 'update topics updated date' do
    context 'when business backlink service is false' do
      it 'not update topics' do
        expect(data).to be_nil
      end
    end

    context 'when business backlink service is true' do
      let(:business) { build(:business, backlink_service: true) }
      let(:backlink_datum) { build(:backlink_datum, business: business) }

      before do
        allow(Majestic).to receive(:get_topics).and_return('topic')
      end

      it 'update topics' do
        backlink_datum
        expect(data.topics).to eq('topic')
      end
    end

    context 'when updated at greater than 7 days' do
      let(:business) { build(:business, backlink_service: true) }
      let(:backlink_datum) { build(:backlink_datum, topics_updated_at: Time.zone.today - 8.days, business: business) }

      it 'not update topics' do
        backlink_datum
        expect(data).to be_nil
      end
    end
  end
end
