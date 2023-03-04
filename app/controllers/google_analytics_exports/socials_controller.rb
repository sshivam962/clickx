# frozen_string_literal: true

module GoogleAnalyticsExports
  class SocialsController < ApplicationController
    def index
      @business = Business.find(params[:id])
      authorize @business, :client_level_manage?
      @data = social_referral.fetch
      @socials_data = Analytics::SocialsPresenter.new(@data)
      respond_to do |format|
        format.pdf do
          render pdf: 'analytics_export.pdf',
                 print_media_type: true
        end
        format.json { render json: @data }
      end
    end

    private

    def social_referral
      GoogleAnalytics::SocialReferrals.new(@business, params)
    end
  end
end
