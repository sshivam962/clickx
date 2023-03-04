# frozen_string_literal: true

require 'rails_helper'

describe RefDomainsPresenter do
  let(:complete_data_presenter) { described_class.new(valid_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:valid_data) do
    { 'Domain' => 'trafficshopping.com',
      'AlexaRank' => 2,
      'CitationFlow' => 44,
      'TrustFlow' => 11,
      'TopicalTrustFlow_Topic_0' => 'Computers/Internet/Web Design and Development',
      'TopicalTrustFlow_Value_0' => 11,
      'ExtBackLinks' => 417_339 }
  end

  let(:incomplete_data) do
    { 'Domain' => '',
      'AlexaRank' => -1,
      'CitationFlow' => nil,
      'TrustFlow' => nil,
      'TopicalTrustFlow_Topic_0' => '',
      'TopicalTrustFlow_Value_0' => nil,
      'ExtBackLinks' => nil }
  end

  describe '#referring_domains' do
    context 'when referring domains is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.referring_domains).to eq('NA')
      end
    end

    context 'when referring_domains is present' do
      it 'returns domain' do
        expect(complete_data_presenter.referring_domains).to eq(valid_data['Domain'])
      end
    end
  end

  describe '#trust_flow' do
    context 'when trust flow is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.trust_flow).to eq('NA')
      end
    end

    context 'when trust flow is present' do
      it 'returns trust flow' do
        expect(complete_data_presenter.trust_flow).to eq(valid_data['TrustFlow'])
      end
    end
  end

  describe '#citation_flow' do
    context 'when citation flow is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.citation_flow).to eq('NA')
      end
    end

    context 'when citation flow is present' do
      it 'returns citation flow' do
        expect(complete_data_presenter.citation_flow).to eq(valid_data['CitationFlow'])
      end
    end
  end

  describe '#backlinks' do
    context 'when backlinks is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.backlinks).to eq('NA')
      end
    end

    context 'when backlinks is present' do
      it 'returns backlinks' do
        expect(complete_data_presenter.backlinks).to eq(valid_data['ExtBackLinks'])
      end
    end
  end

  describe '#alexa_rank' do
    context 'when alexa rank is greater than 1' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.alexa_rank).to eq('N/A')
      end
    end

    context 'when alexa_rank is present' do
      it 'returns alexa rank' do
        expect(complete_data_presenter.alexa_rank).to eq(valid_data['AlexaRank'])
      end
    end
  end

  describe '#primary_topical_tf' do
    context 'when primary topical tf is present' do
      it 'returns primary topical tf' do
        expect(complete_data_presenter.primary_topical_tf).to eq("[#{valid_data['TopicalTrustFlow_Value_0']}] #{valid_data['TopicalTrustFlow_Topic_0']}")
      end
    end
  end
end
