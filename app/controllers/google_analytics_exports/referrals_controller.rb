# frozen_string_literal: true

module GoogleAnalyticsExports
  class ReferralsController < ApplicationController
    def index
      @business = Business.find(params[:id])
      authorize @business, :client_level_manage?
      @data = referrals.fetch
      @referrals_data = Analytics::ReferralPresenter.new(@data)
      respond_to do |format|
        format.pdf do
          render pdf: 'referrals_export.pdf',
                 print_media_type: true
        end
        format.json { render json: @data }
      end
    end

    private

    def referrals
      GoogleAnalytics::Referrals.new(@business, params)
    end
  end
end
