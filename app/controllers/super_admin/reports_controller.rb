# frozen_string_literal: true

class SuperAdmin::ReportsController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_business, only: %i[archive_client change_keyword_ranking keywords_export]

  def index; end

  def archive_client
    @client.destroy
    flash[:notice] = 'Client Archived'
    redirect_to client_super_admin_reports_path
  end

  def change_keyword_ranking
    @client.toggle!(:keyword_ranking_service)
  end

  def client
    @clients = Business.includes(:locations, :keywords)
  end

  def google_ads
    @agencies =
      Agency.includes(:businesses).where.not(
        businesses: { google_analytics_id: EMPTY }
      )
  end

  def google_clients
    @clients = Business.includes(:google_ad_reports)
                       .not_free.analytics_connected
                       .where(agency_id: params[:agency_id])
  end

  def facebook_ads
    @agencies =
      Agency.includes(:businesses).where.not(
        businesses: { fb_ad_account_id: nil }
      )
  end

  def facebook_clients
    @clients = Business.includes(:fb_ad_reports)
                       .not_free.facebook_ads_enabled
                       .where(agency_id: params[:agency_id])
  end

  def keywords_export
    @keywords = @client.keywords.active
    respond_to do |format|
      format.json do
        render json: { status: 200, data: @keywords.as_json }
      end
      format.csv { send_data @keywords.to_csv }
    end
  end

  private

  def set_business
    @client = Business.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin report]
  end
end
