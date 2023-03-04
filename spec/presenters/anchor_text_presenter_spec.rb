# frozen_string_literal: true

require 'rails_helper'

describe AnchorTextPresenter do
  let(:complete_data_presenter) { described_class.new(valid_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:valid_data) do
    { 'AnchorText' => 'clickx',
      'TopicalTrustFlow_Topic_0' => 'Computers/Internet/Web Design and Development',
      'RefDomains' => '68',
      'TotalLinks' => '207',
      'DeletedLinks' => '15',
      'NoFollowLinks' => '60' }
  end

  let(:incomplete_data) do
    { 'AnchorText' => '',
      'TopicalTrustFlow_Topic_0' => '',
      'RefDomains' => '',
      'TotalLinks' => '',
      'DeletedLinks' => '',
      'NoFollowLinks' => '' }
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

  describe '#topics' do
    context 'when topics is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.topics).to eq('NA')
      end
    end

    context 'when topics is present' do
      it 'returns topics' do
        expect(complete_data_presenter.topics).to eq(valid_data['TopicalTrustFlow_Topic_0'])
      end
    end
  end

  describe '#referring_domains' do
    context 'when referring domains is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.referring_domains).to eq('NA')
      end
    end

    context 'when referring_domains is present' do
      it 'returns referring_domains' do
        expect(complete_data_presenter.referring_domains).to eq(valid_data['RefDomains'])
      end
    end
  end

  describe '#total_links' do
    context 'when total links is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.total_links).to eq('NA')
      end
    end

    context 'when total links is present' do
      it 'returns total links' do
        expect(complete_data_presenter.total_links).to eq(valid_data['TotalLinks'])
      end
    end
  end

  describe '#deleted_links' do
    context 'when deleted links is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.deleted_links).to eq('NA')
      end
    end

    context 'when deleted links is present' do
      it 'returns deleted links' do
        expect(complete_data_presenter.deleted_links).to eq(valid_data['DeletedLinks'])
      end
    end
  end

  describe '#no_follow_links' do
    context 'when number of follow links is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.no_follow_links).to eq('NA')
      end
    end

    context 'when number of follow links is present' do
      it 'returns number of follow links' do
        expect(complete_data_presenter.no_follow_links).to eq(valid_data['NoFollowLinks'])
      end
    end
  end
end
