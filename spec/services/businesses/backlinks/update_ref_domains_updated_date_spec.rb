# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Businesses::Backlinks::UpdateRefDomainsUpdatedDate do
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
        allow(Majestic).to receive(:get_ref_domain).and_return('ref_domain')
      end

      it 'update ref_domains' do
        backlink_datum
        expect(data.ref_domains).to eq('ref_domain')
      end
    end

    context 'when updated at less than 7 days' do
      let(:business) { build(:business, backlink_service: true) }
      let(:backlink_datum) { build(:backlink_datum, ref_domains_updated_at: Time.zone.today - 9.days, business: business) }

      it 'not update ref_domains' do
        VCR.use_cassette('majestic/ref_domain', match_requests_on: %i[host]) do
          backlink_datum
          expect(data).to eq(backlink_datum)
        end
      end
    end
  end
end
