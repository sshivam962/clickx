# frozen_string_literal: true

require 'rails_helper'

describe Analytics::SearchPresenter do
  let(:complete_data_presenter) { described_class.new(complete_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:complete_data) do
    {
      "keywords_stats" =>
      [{ keyword: "(not provided)",
         visits: "4",
         new_visits: 0.0,
         bounce: 1.0,
         avg_session: "01:15",
         page_per_session: 11.5 }]
    }
  end

  let(:incomplete_data) do
    {
      "keywords_stats" =>
      [{ keyword: "",
         visits: "",
         new_visits: nil,
         bounce: nil,
         avg_session: "",
         page_per_session: nil }]
    }
  end

  describe '#keyword' do
    context 'when keyword is present' do
      it 'returns keyword' do
        expect(complete_data_presenter.keyword).to eq(complete_data.dig('keywords_stats').try(:first).dig(:keyword))
      end
    end

    context 'when keyword is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.keyword).to eq('NA')
      end
    end
  end

  describe '#visits' do
    context 'when overall visits is present' do
      it 'returns visits' do
        expect(complete_data_presenter.visits).to eq(complete_data.dig('keywords_stats').try(:first).dig(:visits))
      end
    end

    context 'when overall visits is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.visits).to eq('NA')
      end
    end
  end

  describe '#new_visits' do
    context 'when overall new visit is present' do
      it 'returns new visits' do
        expect(complete_data_presenter.new_visits).to eq(complete_data.dig('keywords_stats').try(:first).dig(:new_visits))
      end
    end

    context 'when overall new visit is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.new_visits).to eq('NA')
      end
    end
  end

  describe '#bounce' do
    context 'when bounce rate is present' do
      it 'returns bounce rate' do
        expect(complete_data_presenter.bounce).to eq(complete_data.dig('keywords_stats').try(:first).dig(:bounce))
      end
    end

    context 'when bounce rate is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.bounce).to eq('NA')
      end
    end
  end

  describe '#avg_session' do
    context 'when average session is present' do
      it 'returns average session' do
        expect(complete_data_presenter.avg_session).to eq(complete_data.dig('keywords_stats').try(:first).dig(:avg_session))
      end
    end

    context 'when average session is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.avg_session).to eq('NA')
      end
    end
  end

  describe '#page_per_session' do
    context 'when overall pages per session is present' do
      it 'returns keyword' do
        expect(complete_data_presenter.page_per_session).to eq(complete_data.dig('keywords_stats').try(:first).dig(:page_per_session))
      end
    end

    context 'when pages per session is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.page_per_session).to eq('NA')
      end
    end
  end

  describe '#decorated_chart_data' do
    before do
      @chart_data = { 'chart_data' => { chart_rows: { '20180708' => [0.0, 0.0, 0.0, 0.0, 0.0, 0.0] } } }
      @decorated_chart_data = described_class.new(@chart_data)
    end
    context 'when chart data is present' do
      it 'returns chart data' do
        expect(@decorated_chart_data.decorated_chart_data[0][:data]).to eq(@chart_data['chart_data'][:chart_rows]['20180708'])
      end
    end
  end
end
