# frozen_string_literal: true

class Businesses::SiteAuditsController < ApplicationController
  include Majestic
  %i[
    site_audit_issues_data site_audit_seo_analytics site_audit_backlink
    site_audit_ranking_metrics leo_report_rows
  ].each do |key|
    before_action -> { stub_with_dummy_data(key: key) }, only: key
  end

  before_action :get_business
  before_action -> { authorize @business, :client_level_manage? }

  def site_audit_ranking_metrics
    keywords = latest_keyword_ranking
    if keywords && params[:offset] && params[:limit]
      data = keywords.drop(params[:offset].to_i).first(params[:limit].to_i)
      render json: { data: data, keyword_limit: @business.keyword_limit,
                     total_size: keywords.count }, status: 200
    else
      render json: { errors: 'No data available', status: 404 }, status: 200
    end
  end

  def site_audit_backlink
    if @business.backlink_service
      begin
        url_backlinks = fetch_backlinks
        if url_backlinks
          data = url_backlinks.drop(params[:offset].to_i).first(params[:limit].to_i)
          render json: { data: data,
                         total_size: url_backlinks.count }, status: 200 and return
        else
          render json: { errors: 'No data Available', status: 404 }, status: 200 and return
        end
      rescue StandardError
        render json: { business: @business,
                       errors: 'Error in fetching backlinks' }, status: 406 and return
      end
    else
      render json: { business: @business,
                     errors: 'Business not yet opted for backlinks.' }, status: 406 and return
    end
  end

  def site_audit_seo_analytics
    data = {}
    ssl = SiteAudit::CheckSSL.call(@business)
    xml = SiteAudit::XMLSitemap.call(@business)
    version = SiteAudit::VersionCheck.call(@business)
    robots = SiteAudit::CheckRobots.call(@business)
    data[:ssl] = if ssl.success?
                   { status: 200, response: ssl.payload }
                 else
                   { status: :not_found, response: ssl.payload }
    end
    data[:xml] = if xml.success?
                   { status: 200, response: xml.payload }
                 else
                   { status: :not_found, response: xml.payload }
    end
    data[:version] = if version.success?
                       { status: 200, response: version.payload }
                     else
                       { status: :not_found, response: version.payload }
    end
    data[:robots] = if robots.success?
                      { status: 200, response: robots.payload }
                    else
                      { status: :not_found, response: robots.payload }
    end
    render json: { status: 200, data: data }
  end

  def leo_report_rows
    if params[:url]
      if report_rows.success?
        if report_rows.payload[:error].nil?
          respond_to do |format|
            format.json { render json: report_rows.payload, status: 200 }
            format.csv { send_data to_csv(report_rows.payload[:data]) }
          end
        else
          render json: report_rows.payload, status: :not_found
        end
      else
        render json: report_rows.payload, status: :not_found
      end
    else
      render json: { message: 'Sorry! Report link not available' }, status: :not_found
    end
  end

  def site_audit_issues_data
    response = SiteAudit::IssuesData.call(@business, params)
    if response.success?
      render json: response.payload, status: 200
    else
      render json: response.payload, status: :not_found
    end
  end

  def site_audit_edit_content
    infos = params[:data]
    if infos.present?
      infos.each do |topic, data|
        data['data'].each do |info|
          next unless info['issue_type']
          site_audit_content = SiteAuditIssueInfo.find_or_create_by(issue_type: info['issue_type'])
          site_audit_content&.update_attributes(
              error_description: info[:error_description],
              passed_description: info[:passed_description],
              error_title: info[:error_title],
              passed_title: info[:passed_title]
)
        end
        site_audit_details = SiteAuditDetail.first
        site_audit_details ||= SiteAuditDetail.new
        site_audit_details.update_attributes(topic => data['description'])
      end
      head :ok
    else
      head :not_found
    end
  end

  private

  def get_business
    # request.env is used to resolve an open issue of callback_url in omniauth-facebook gem
    @business = Business.find(params[:id] || request.env['omniauth.params']['id'])
  end

  def latest_keyword_ranking
    return nil unless params[:url]
    latest_data = Businesses::KeywordRanks.fetch(@business, params)
    metrics_data =
      latest_data.reject { |d| d['googleRankingUrl'].nil? }
                 .group_by { |d| d['googleRankingUrl'].split('://').last }
    metrics_data[params[:url].split('://').last]
  end

  def fetch_backlinks
    update_backlinks
    backlinks = @business.backlink_datum.backlinks
    return unless backlinks
    matrics = backlinks.group_by { |d| d['TargetURL'].split('://').last }
    return nil unless matrics && params[:url]
    matrics[params['url'].split('://').last]
  end

  def update_backlinks
    unless @business.backlink_datum
      @business.build_backlink_datum
      @business.backlink_datum
               .update_attributes(backlinks_updated_at: 10.days.ago)
    end
    @business.backlink_datum.update_attributes(backlinks_updated_at: 10.days.ago) if @business.backlink_datum.backlinks_updated_at.blank?
    updated_at = @business.backlink_datum.backlinks_updated_at
    update_backlinks_data if updated_at < 7.days.ago
  end

  def update_backlinks_data
    response = get_backlinks(URI(@business.domain).host)
    @business.backlink_datum.update_attributes(backlinks: response,
                                               backlinks_updated_at: Time.zone.now)
  end

  def to_csv(data)
    attributes = %w[Title Description Status]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      data[0].values.flatten.each do |values|
        values['data'].each do |hash|
          next unless hash['issue_type']
          record = []
          record << hash['issue_type'].humanize
          record << if hash['status'] == 'passed'
                      hash['passed_description']
                    else
                      hash['error_description']
                    end
          record << hash['status']
          csv << record
        end
      end
    end
  end

  def report_rows
    @_report_rows ||= SiteAudit::ReportRows.call(@business, params)
  end
end
