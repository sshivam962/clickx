# frozen_string_literal: true

require 'rails_helper'

describe TopPagesPresenter do
  let(:complete_data_presenter) { described_class.new(valid_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:valid_data) do
    { 'URL' => 'http://www.clickx.io/',
      'ExtBackLinks' => '366',
      'RefDomains' => '116',
      'TrustFlow' => '21',
      'CitationFlow' => '31' }
  end

  let(:incomplete_data) do
    { 'URL' => '',
      'ExtBackLinks' => '',
      'RefDomains' => '',
      'TrustFlow' => '',
      'CitationFlow' => '' }
  end

  describe '#page' do
    context 'when page is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.page).to eq('NA')
      end
    end

    context 'when page is present' do
      it 'returns page' do
        expect(complete_data_presenter.page).to eq(valid_data['URL'])
      end
    end
  end

  describe '#external_backlinks' do
    context 'when external backlinks is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.external_backlinks).to eq('NA')
      end
    end

    context 'when external backlinks is present' do
      it 'returns external backlinks' do
        expect(complete_data_presenter.external_backlinks).to eq(valid_data['ExtBackLinks'])
      end
    end
  end

  describe '#referring_domains' do
    context 'when referring domains is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.referring_domains).to eq('NA')
      end
    end

    context 'when referring domains is present' do
      it 'returns referring domains' do
        expect(complete_data_presenter.referring_domains).to eq(valid_data['RefDomains'])
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
end
