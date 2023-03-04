# frozen_string_literal: true

require 'rails_helper'

describe Analytics::TopPagesPresenter do
  describe '#table_data' do
    before do
      @data = { "table_data" =>
                [{ site: "/report/R6UFQL9UX38",
                   sessions: "3", page_views: "3", avg_session: "00:00:00",
                   data_hub: 0, page_per_session: 1.0 }] }
      @table_data = described_class.new(@data)
      allow(Analytics::TopPresenter).to receive(:new).and_return(@data["table_data"][0])
    end
    context 'when table data is present' do
      it 'returns table data' do
        expect(@table_data.table_data[0]).to eq(@data["table_data"][0])
      end
    end
  end
end
