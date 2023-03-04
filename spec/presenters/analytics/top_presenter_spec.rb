# frozen_string_literal: true

require 'rails_helper'

describe Analytics::TopPresenter do
  let(:complete_data_presenter) { described_class.new(complete_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:complete_data) do
    {
      site: '/report/R6UFQL9UX38',
      sessions: '3', page_views: '3', avg_session: '00:00:00',
      data_hub: 0, page_per_session: 1.0
    }
  end

  let(:incomplete_data) do
    {
      site: '',
      sessions: '', page_views: '', avg_session: '',
      data_hub: nil, page_per_session: nil
    }
  end

  describe '#site' do
    context 'when site is present' do
      it 'returns site' do
        expect(complete_data_presenter.site).to eq(complete_data[:site])
      end
    end

    context 'when site is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.site).to eq('NA')
      end
    end
  end

  describe '#sessions' do
    context 'when overall sessions is present' do
      it 'returns sessions' do
        expect(complete_data_presenter.sessions).to eq(complete_data[:sessions])
      end
    end

    context 'when overall sessions is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.sessions).to eq('NA')
      end
    end
  end

  describe '#page_views' do
    context 'when overall page views is present' do
      it 'returns new visits' do
        expect(complete_data_presenter.page_views).to eq(complete_data[:page_views])
      end
    end

    context 'when overall page views is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.page_views).to eq('NA')
      end
    end
  end

  describe '#avg_session' do
    context 'when average session is present' do
      it 'returns average session' do
        expect(complete_data_presenter.avg_session).to eq(complete_data[:avg_session])
      end
    end

    context 'when average session is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.avg_session).to eq('NA')
      end
    end
  end

  describe '#data_hub' do
    context 'when data hub is present' do
      it 'returns data hub' do
        expect(complete_data_presenter.data_hub).to eq(complete_data[:data_hub])
      end
    end

    context 'when data hub is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.data_hub).to eq('NA')
      end
    end
  end

  describe '#page_per_session' do
    context 'when overall pages per session is present' do
      it 'returns keyword' do
        expect(complete_data_presenter.page_per_session).to eq(complete_data[:page_per_session])
      end
    end

    context 'when pages per session is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.page_per_session).to eq('NA')
      end
    end
  end
end
