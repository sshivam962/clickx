# frozen_string_literal: true

require 'rails_helper'

describe BacklinksPresenter do
  let(:complete_data_presenter) { described_class.new(valid_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:valid_data) do
    { 'SourceURL' => 'https://pledge1percent.org/pledged.html',
      'SourceTrustFlow' => '41',
      'SourceCitationFlow' => '40',
      'LinkType' => 'ImageLink',
      'FirstIndexedDate' => '2018-04-26',
      'LastSeenDate' => '2018-07-20',
      'AnchorText' => 'clickx' }
  end

  let(:incomplete_data) do
    { 'SourceURL' => '',
      'SourceTrustFlow' => '',
      'SourceCitationFlow' => '',
      'LinkType' => '',
      'FirstIndexedDate' => '',
      'LastSeenDate' => '',
      'AnchorText' => '' }
  end

  describe '#referring_page' do
    context 'when referring page is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.referring_page).to eq('NA')
      end
    end

    context 'when referring page is present' do
      it 'returns referring page' do
        expect(complete_data_presenter.referring_page).to eq(valid_data['SourceURL'])
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
        expect(complete_data_presenter.trust_flow).to eq(valid_data['SourceTrustFlow'])
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
        expect(complete_data_presenter.citation_flow).to eq(valid_data['SourceCitationFlow'])
      end
    end
  end

  describe '#link_type' do
    context 'when link type is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.link_type).to eq('NA')
      end
    end

    context 'when link type is present' do
      it 'returns link type' do
        expect(complete_data_presenter.link_type).to eq(valid_data['LinkType'])
      end
    end
  end

  describe '#first_indexed_date' do
    context 'when first indexed date is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.first_indexed_date).to eq('NA')
      end
    end

    context 'when first indexed date is present' do
      it 'returns first indexed date' do
        expect(complete_data_presenter.first_indexed_date).to eq(valid_data['FirstIndexedDate'])
      end
    end
  end

  describe '#last_seen_date' do
    context 'when last seen date is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.last_seen_date).to eq('NA')
      end
    end

    context 'when last seen date is present' do
      it 'returns last seen date' do
        expect(complete_data_presenter.last_seen_date).to eq(valid_data['LastSeenDate'])
      end
    end
  end

  describe '#anchor_text' do
    context 'when anchor text is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.anchor_text).to eq('NA')
      end
    end

    context 'when anchor text is present' do
      it 'returns anchor text' do
        expect(complete_data_presenter.anchor_text).to eq(valid_data['AnchorText'])
      end
    end
  end
end
