# frozen_string_literal: true

class Business::FacebookAdsController < Business::BaseController
  include DateFormatter

  before_action :set_dates
  before_action :check_service
  before_action :auto_update_campaigns, only: %i[campaigns]

  def campaigns
    @graph_data = graph_data
    @data = Facebook::Campaigns::Insights.fetch(
      graph, fb_ad_account, @start_date, @end_date
    )
    render_response
  end

  def adsets
    @graph_data = graph_data
    @data = Facebook::Adsets::Insights.fetch(
      graph, fb_ad_account, @start_date, @end_date
    )
    render_response
  end

  def ads
    @graph_data = graph_data
    @data = Facebook::Ads::Insights.fetch(
      graph, fb_ad_account, @start_date, @end_date
    )
    render_response
  end

  def ad_preview
    preview = Facebook::Ads::AdPreview.fetch(graph, params[:creative_id])
    @data = preview.first['body']

    render_response
  end

  private

  def check_service
    return if fb_ad_account

    flash[:notice] = 'No Ad Acccount connected, please integrate Facebook Ads'
    redirect_to root_path and return
  end

  def set_dates
    @start_date =
      (parse_us_format_string(params[:start_date]) || 30.days.ago.to_date).to_s
    @end_date =
      (parse_us_format_string(params[:end_date]) || Time.current.to_date).to_s
  end

  def render_response
    respond_to do |format|
      format.js
      format.html
    end
  end

  def fb_ad_account
    @_fb_ad_account ||= current_business.fb_ad_account
  end

  def graph
    @_graph ||= Koala::Facebook::API.new(current_business.fb_access_token)
  end

  def auto_update_campaigns
    all_campaigns = Facebook::Campaigns::Insights.all_campaigns(
      graph, fb_ad_account.account_id
    )
    campaign_ids = all_campaigns[:campaigns].map{ |x| x['id'] }
    fb_ad_account.update(campaign_ids: campaign_ids)
  end

  def graph_data
    @_graph_data ||= Facebook::GraphData.fetch(
      graph, fb_ad_account, @start_date, @end_date
    )
  end
end
