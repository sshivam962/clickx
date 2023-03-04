# frozen_string_literal: true

require 'rails_helper'

describe Analytics::OverviewPresenter do
  let(:complete_data_presenter) { described_class.new(complete_data) }

  let(:incomplete_data_presenter) { described_class.new(incomplete_data) }

  let(:complete_data) do
    {
      'totals' => {
        'ga:users' => '6',
        'ga:pageviews' => '13',
        'ga:sessions' => '10'
      },
      'visit_status' => {
        referral: 1,
        organic: 4,
        direct: 5,
        paid: 2,
        social: 3,
        email: 6,
        others: 7
      }
    }
  end

  let(:incomplete_data) do
    {
      "totals" => {
        "ga:users" => "",
        "ga:pageviews" => "",
        "ga:sessions" => ""
      },
      "visit_status" => {
        referral: nil,
        organic: nil,
        direct: nil,
        paid: nil,
        social: nil,
        email: nil,
        others: nil
      }
    }
  end

  describe '#sessions' do
    context 'when sessions count is present' do
      it 'returns sessions count' do
        expect(complete_data_presenter.sessions).to eq(complete_data['totals']['ga:sessions'])
      end
    end

    context 'when sessions count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.sessions).to eq('NA')
      end
    end
  end

  describe '#users' do
    context 'when users count is present' do
      it 'returns users count' do
        expect(complete_data_presenter.users).to eq(complete_data['totals']['ga:users'])
      end
    end

    context 'when users count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.users).to eq('NA')
      end
    end
  end

  describe '#page_views' do
    context 'when page views count is present' do
      it 'returns page views count' do
        expect(complete_data_presenter.page_views).to eq(complete_data['totals']['ga:pageviews'])
      end
    end

    context 'when page views count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.page_views).to eq('NA')
      end
    end
  end

  describe '#referral' do
    context 'when referral count is present' do
      it 'returns referral count' do
        expect(complete_data_presenter.referral).to eq(complete_data['visit_status'][:referral])
      end
    end

    context 'when referral count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.referral).to eq('NA')
      end
    end
  end

  describe '#organic' do
    context 'when organic count is present' do
      it 'returns organic count' do
        expect(complete_data_presenter.organic).to eq(complete_data['visit_status'][:organic])
      end
    end

    context 'when organic count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.organic).to eq('NA')
      end
    end
  end

  describe '#direct' do
    context 'when direct count is present' do
      it 'returns direct count' do
        expect(complete_data_presenter.direct).to eq(complete_data['visit_status'][:direct])
      end
    end

    context 'when direct count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.direct).to eq('NA')
      end
    end
  end

  describe '#paid' do
    context 'when paid count is present' do
      it 'returns paid count' do
        expect(complete_data_presenter.paid).to eq(complete_data['visit_status'][:paid])
      end
    end

    context 'when paid count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.paid).to eq('NA')
      end
    end
  end

  describe '#social' do
    context 'when social count is present' do
      it 'returns social count' do
        expect(complete_data_presenter.social).to eq(complete_data['visit_status'][:social])
      end
    end

    context 'when social count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.social).to eq('NA')
      end
    end
  end

  describe '#email' do
    context 'when email count is present' do
      it 'returns email count' do
        expect(complete_data_presenter.email).to eq(complete_data['visit_status'][:email])
      end
    end

    context 'when email count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.email).to eq('NA')
      end
    end
  end

  describe '#others' do
    context 'when others count is present' do
      it 'returns others count' do
        expect(complete_data_presenter.others).to eq(complete_data['visit_status'][:others])
      end
    end

    context 'when others count is blank' do
      it 'fall back to NA' do
        expect(incomplete_data_presenter.others).to eq('NA')
      end
    end
  end

  describe '#decorated_user_data' do
    before do
      @users_data = { 'users_data' => { '20180708' => [0.0, 0.0, 0.0, 0.0, 0.0, 0.0] } }
      @decorated_user_data = described_class.new(@users_data)
    end
    context 'when users data is present' do
      it 'returns users data' do
        expect(@decorated_user_data.decorated_user_data[0][:data]).to eq(@users_data['users_data']['20180708'])
      end
    end
  end
end
