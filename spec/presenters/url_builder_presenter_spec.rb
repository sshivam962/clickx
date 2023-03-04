# frozen_string_literal: true

require 'rails_helper'

describe UrlBuilderPresenter do
  subject(:presenter) { described_class.new(custom_url) }

  let(:custom_url) { build_stubbed(:custom_url) }

  describe '#campaign_name' do
    context 'when camapign_name is blank' do
      let(:custom_url) { build_stubbed(:custom_url, campaign_name: '') }

      it 'fall back to NA' do
        expect(presenter.campaign_name).to eq('NA')
      end
    end

    context 'when campaign_name is present' do
      it 'returns campaign_name' do
        expect(presenter.campaign_name).to eq(custom_url.campaign_name)
      end
    end
  end

  describe '#complete_url' do
    context 'when complete_url is blank' do
      let(:custom_url) { build_stubbed(:custom_url, complete_url: '') }

      it 'fall back to NA' do
        expect(presenter.complete_url).to eq('NA')
      end
    end

    context 'when complete_url is present' do
      it 'returns complete_url' do
        expect(presenter.complete_url).to eq(custom_url.complete_url)
      end
    end
  end

  describe '#campaign_source' do
    context 'when campaign_source is blank' do
      let(:custom_url) { build_stubbed(:custom_url, campaign_source: '') }

      it 'fall back to NA' do
        expect(presenter.campaign_source).to eq('NA')
      end
    end

    context 'when campaign_source is present' do
      it 'returns campaign_source' do
        expect(presenter.campaign_source).to eq(custom_url.campaign_source)
      end
    end
  end
end
