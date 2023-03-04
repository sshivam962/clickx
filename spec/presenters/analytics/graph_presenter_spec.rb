# frozen_string_literal: true

require 'rails_helper'

describe Analytics::GraphPresenter do
  let(:graph_data) { described_class.new(complete_data) }
  let(:complete_data) { { 'users_data' => { '20180708' => [50.0, 2.0, 2.0, 50.0, 23.0, 1.5] } } }

  describe '#formatted_date' do
    context 'when date is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: complete_data))
      end
      it 'returns date' do
        expect(graph_data.formatted_date).to eq('2018-07-08')
      end
    end

    context 'when date is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '', data: complete_data))
      end
      it 'fall back to NA' do
        expect(graph_data.formatted_date).to eq('NA')
      end
    end
  end

  describe '#users_count' do
    context 'when users count is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, 2.0, 2.0, 50.0, 23.0, 1.5]))
      end
      it 'returns users count' do
        expect(graph_data.users_count).to eq(2)
      end
    end

    context 'when users count is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, nil, 2.0, 50.0, 23.0, 1.5]))
      end
      it 'fall back to NA' do
        expect(graph_data.users_count).to eq('NA')
      end
    end
  end

  describe '#pages_per_session' do
    context 'when pages per session is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, 2.0, 2.0, 50.0, 23.0, 1.5]))
      end
      it 'returns page views count' do
        expect(graph_data.pages_per_session).to eq(23.0)
      end
    end

    context 'when pages per session is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, 2.0, 2.0, 50.0, nil, 1.5]))
      end
      it 'fall back to NA' do
        expect(graph_data.pages_per_session).to eq('NA')
      end
    end
  end

  describe '#avg_session_duration' do
    context 'when average session duration is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, 2.0, 2.0, 50.0, 23.0, 1.5]))
      end
      it 'returns average session duration' do
        expect(graph_data.avg_session_duration).to eq('00:00:50')
      end
    end

    context 'when average session duration is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, 2.0, 2.0, nil, 23.0, 1.5]))
      end
      it 'fall back to NA' do
        expect(graph_data.avg_session_duration).to eq('NA')
      end
    end
  end

  describe '#new_sessions' do
    context 'when new sessions is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, 2.0, 2.0, 50.0, 23.0, 1.5]))
      end
      it 'returns direct count' do
        expect(graph_data.new_sessions).to eq(50.0)
      end
    end

    context 'when new sessions is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [nil, 2.0, 2.0, 50.0, 23.0, 1.5]))
      end
      it 'fall back to NA' do
        expect(graph_data.new_sessions).to eq('NA')
      end
    end
  end

  describe '#bounce_rate' do
    context 'when bounce rate is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, 2.0, 2.0, 50.0, 23.0, 1.5]))
      end
      it 'returns direct count' do
        expect(graph_data.bounce_rate).to eq(2.0)
      end
    end

    context 'when bounce rate is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '20180708', data: [50.0, 2.0, nil, 50.0, 23.0, 1.5]))
      end
      it 'fall back to NA' do
        expect(graph_data.bounce_rate).to eq('NA')
      end
    end
  end
end
