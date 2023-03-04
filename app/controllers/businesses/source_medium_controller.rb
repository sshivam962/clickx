# frozen_string_literal: true
class Businesses::SourceMediumController < BusinessesController
  before_action -> { stub_with_dummy_data(key: google_source_medium) }

  def google_source_medium
    @data = GoogleAnalytics::SourceMedium.new(
      @start_date, @end_date, @auth_google_client,
      @business.google_analytics_id, params
    ).get_campaigns_data
    respond_to do |format|
      format.pdf do
        render pdf: 'source_medium.pdf',
               print_media_type: true
      end
      format.json do
        render json: { status: 200, data: @data } and return
      end
    end
  end
end
