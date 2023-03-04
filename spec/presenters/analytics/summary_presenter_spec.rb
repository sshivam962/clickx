# frozen_string_literal: true

require 'rails_helper'

describe Analytics::SummaryPresenter do
  let(:complete_data_presenter) { described_class.new(valid_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:valid_data) do
    { total_details: ['Total', '--', '0', '0', '0', '0', '0.00%', '0.00', 0, 0] }
  end

  let(:incomplete_data) do
    { total_details: ['', '', '', '', '', '', '', '', '', ''] }
  end

  describe '#impressions' do
    context 'when impressions is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.impressions).to eq('NA')
      end
    end

    context 'when impressions is present' do
      it 'returns impressions' do
        expect(complete_data_presenter.impressions).to eq('0')
      end
    end
  end

  describe '#avg_cost' do
    context 'when average cost is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.avg_cost).to eq('NA')
      end
    end

    context 'when average cost is present' do
      it 'returns average cost' do
        expect(complete_data_presenter.avg_cost).to eq(0)
      end
    end
  end

  describe '#integrations_clicks' do
    context 'when integrations is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.integrations_clicks).to eq('NA')
      end
    end

    context 'when integrations is present' do
      it 'returns integrations' do
        expect(complete_data_presenter.integrations_clicks).to eq('0')
      end
    end
  end

  describe '#cost' do
    context 'when cost is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.cost).to eq('NA')
      end
    end

    context 'when cost is present' do
      it 'returns cost' do
        expect(complete_data_presenter.cost).to eq(0)
      end
    end
  end

  describe '#interaction_rate' do
    context 'when interaction rate is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.interaction_rate).to eq('NA')
      end
    end

    context 'when interaction rate is present' do
      it 'returns interaction rate' do
        expect(complete_data_presenter.interaction_rate).to eq('0.00%')
      end
    end
  end

  describe '#conversion' do
    context 'when conversion is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.conversion).to eq('NA')
      end
    end

    context 'when conversion is present' do
      it 'returns conversion' do
        expect(complete_data_presenter.conversion).to eq('0.00')
      end
    end
  end

  describe '#decorated_user_data' do
    before do
      @users_data = { this_period:                                       { 'Mon 09 Jul 2018' => { clicks: 0,
                                                                                                  impressions: 0, conversions: 0,
                                                                                                  avg_cost: 0, cost: 0, ctr: 0 } } }
      @decorated_user_data = described_class.new(@users_data)
    end
    context 'when users data is present' do
      it 'returns users data' do
        expect(@decorated_user_data.decorated_user_data[0][:data]).to eq(@users_data[:this_period]['Mon 09 Jul 2018'])
      end
    end
  end
end
