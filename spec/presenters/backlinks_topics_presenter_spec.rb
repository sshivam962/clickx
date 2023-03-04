# frozen_string_literal: true

require 'rails_helper'

describe BacklinksTopicsPresenter do
  let(:complete_data_presenter) { described_class.new(valid_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:valid_data) do
    { 'Topic' => 'Business',
      'Links' => 30,
      'TopicalTrustFlow' => 26,
      'LinksFromRefDomains' => 1279,
      'RefDomains' => 129 }
  end

  let(:incomplete_data) do
    { 'Topic' => '',
      'Links' => nil,
      'TopicalTrustFlow' => '',
      'LinksFromRefDomains' => '',
      'RefDomains' => nil }
  end

  describe '#topical_trust_flow' do
    context 'when topical trust flow is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.topical_trust_flow).to eq('NA')
      end
    end

    context 'when topical trust flow is present' do
      it 'returns topical trust flow' do
        expect(complete_data_presenter.topical_trust_flow).to eq(valid_data['TopicalTrustFlow'])
      end
    end
  end

  describe '#topic' do
    context 'when topic is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.topic).to eq('NA')
      end
    end

    context 'when topic is present' do
      it 'returns topic' do
        expect(complete_data_presenter.topic).to eq(valid_data['Topic'])
      end
    end
  end

  describe '#links' do
    context 'when links is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.links).to eq('NA')
      end
    end

    context 'when links is present' do
      it 'returns links' do
        expect(complete_data_presenter.links).to eq(valid_data['Links'])
      end
    end
  end

  describe '#links_from_ref_domains' do
    context 'when links from ref domains is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.links_from_ref_domains).to eq('NA')
      end
    end

    context 'when links from ref domains is present' do
      it 'returns links from ref domains' do
        expect(complete_data_presenter.links_from_ref_domains).to eq(valid_data['LinksFromRefDomains'])
      end
    end
  end

  describe '#ref_domains' do
    context 'when ref domains is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.ref_domains).to eq('NA')
      end
    end

    context 'when ref domains is present' do
      it 'returns ref domains' do
        expect(complete_data_presenter.ref_domains).to eq(valid_data['RefDomains'])
      end
    end
  end
end
