# frozen_string_literal: true

require 'rails_helper'

describe Analytics::AdsPresenter do
  describe '#decorated_user_data' do
    before do
      @users_data = { this_period: { 'Mon 09 Jul 2018' =>
                                     { clicks: 0, impressions: 0,
                                       conversions: 0, avg_cost: 0,
                                       cost: 0, ctr: 0 } } }
      @decorated_user_data = described_class.new(@users_data)
    end
    context 'when users data is present' do
      it 'returns users data' do
        expect(@decorated_user_data.decorated_user_data[0][:data])
          .to eq(@users_data[:this_period]['Mon 09 Jul 2018'])
      end
    end
  end
end
