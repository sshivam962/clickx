# frozen_string_literal: true

require 'rails_helper'

describe Analytics::GraphAdsPresenter do
  let(:graph_data) { described_class.new(complete_data) }
  let(:complete_data) do
    { this_period:  { 'Mon, 09 Jul 2018': { clicks: 0,
                                            impressions: 0,
                                            conversions: 0,
                                            avg_cost: 0,
                                            cost: 0,
                                            ctr: 0 } } }
  end
  let(:incomplete_data) do
    { this_period:                      { 'Mon, 09 Jul 2018' => { clicks: '',
                                                                  impressions: '',
                                                                  conversions: '',
                                                                  avg_cost: '',
                                                                  cost: '',
                                                                  ctr: '' } } }
  end

  describe '#date' do
    context 'when date is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: complete_data))
      end
      it 'returns date' do
        expect(graph_data.find_date).to eq('Mon, 09 Jul 2018')
      end
    end

    context 'when date is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: '', data: complete_data))
      end
      it 'fall back to NA' do
        expect(graph_data.find_date).to eq('NA')
      end
    end
  end

  describe '#clicks' do
    context 'when clicks is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: complete_data[:this_period][:'Mon, 09 Jul 2018']))
      end
      it 'returns clicks' do
        expect(graph_data.clicks).to eq(0)
      end
    end

    context 'when click is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: incomplete_data[:this_period]['Mon, 09 Jul 2018']))
      end
      it 'returns clicks' do
        expect(graph_data.clicks).to eq('NA')
      end
    end
  end

  describe '#impression' do
    context 'when impression is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: complete_data[:this_period][:'Mon, 09 Jul 2018']))
      end
      it 'returns impression' do
        expect(graph_data.impression).to eq(0)
      end
    end

    context 'when impression is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: incomplete_data[:this_period]['Mon, 09 Jul 2018']))
      end
      it 'returns impression' do
        expect(graph_data.impression).to eq('NA')
      end
    end
  end

  describe '#cost' do
    context 'when cost is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: complete_data[:this_period][:'Mon, 09 Jul 2018']))
      end
      it 'returns cost' do
        expect(graph_data.cost).to eq(0)
      end
    end

    context 'when cost is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: incomplete_data[:this_period]['Mon, 09 Jul 2018']))
      end
      it 'returns cost' do
        expect(graph_data.cost).to eq('NA')
      end
    end
  end

  describe '#avg_cost' do
    context 'when avg_cost is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: complete_data[:this_period][:'Mon, 09 Jul 2018']))
      end
      it 'returns avg_cost' do
        expect(graph_data.avg_cost).to eq(0)
      end
    end

    context 'when avg_cost is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: incomplete_data[:this_period]['Mon, 09 Jul 2018']))
      end
      it 'returns avg_cost' do
        expect(graph_data.avg_cost).to eq('NA')
      end
    end
  end

  describe '#ctr' do
    context 'when ctr is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: complete_data[:this_period][:'Mon, 09 Jul 2018']))
      end
      it 'returns ctr' do
        expect(graph_data.ctr).to eq(0)
      end
    end

    context 'when ctr is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: incomplete_data[:this_period]['Mon, 09 Jul 2018']))
      end
      it 'returns ctr' do
        expect(graph_data.ctr).to eq('NA')
      end
    end
  end

  describe '#conversions' do
    context 'when conversions is present' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: complete_data[:this_period][:'Mon, 09 Jul 2018']))
      end
      it 'returns conversions' do
        expect(graph_data.conversions).to eq(0)
      end
    end

    context 'when conversions is blank' do
      before do
        graph_data.__setobj__(OpenStruct.new(date: 'Mon, 09 Jul 2018', data: incomplete_data[:this_period]['Mon, 09 Jul 2018']))
      end
      it 'returns conversions' do
        expect(graph_data.conversions).to eq('NA')
      end
    end
  end
end
