# frozen_string_literal: true

require 'rails_helper'

describe CallAnalyticsPresenter do
  let(:complete_data_presenter) { described_class.new(valid_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:valid_data) do
    { 'duration' => '00:00:03',
      'caller_number' => '8885225994',
      'call_s' => '2018-07-30 13:29:38',
      'c_name' => 'Local Maps - Skokie',
      'call_status' => 'CANCEL',
      'caller_name' => 'TALUS PAYMENTS' }
  end

  let(:incomplete_data) do
    { 'duration' => '',
      'caller_number' => '',
      'call_s' => '',
      'c_name' => '',
      'call_status' => '',
      'caller_name' => '' }
  end

  describe '#caller' do
    context 'when caller number is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.caller).to eq('NA')
      end
    end

    context 'when caller number is present' do
      it 'returns caller number' do
        expect(complete_data_presenter.caller).to eq(valid_data['caller_number'])
      end
    end
  end

  describe '#caller_name' do
    context 'when caller name is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.caller_name).to eq('NA')
      end
    end

    context 'when caller name is present' do
      it 'returns caller name' do
        expect(complete_data_presenter.caller_name).to eq(valid_data['caller_name'])
      end
    end
  end

  describe '#campaign' do
    context 'when campaign is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.campaign).to eq('NA')
      end
    end

    context 'when campaign is present' do
      it 'returns campaign' do
        expect(complete_data_presenter.campaign).to eq(valid_data['c_name'])
      end
    end
  end

  describe '#time' do
    context 'when time is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.time).to eq('NA')
      end
    end

    context 'when time is present' do
      it 'returns time' do
        expect(complete_data_presenter.time).to eq(valid_data['call_s'])
      end
    end
  end

  describe '#duration' do
    context 'when duration is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.duration).to eq('NA')
      end
    end

    context 'when duration is present' do
      it 'returns duration' do
        expect(complete_data_presenter.duration).to eq(valid_data['duration'])
      end
    end
  end

  describe '#status' do
    context 'when status is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.status).to eq('NA')
      end
    end

    context 'when status is present' do
      it 'returns status' do
        expect(complete_data_presenter.status).to eq(valid_data['call_status'])
      end
    end
  end
end
