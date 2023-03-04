# frozen_string_literal: true

class RankSummariesController < ApplicationController
  before_action :set_business

  CSV_HEADERS = [
    'Keyword Name', 'Rank'
  ].freeze

  def index
    authorize @business, :client_level_manage?
    rank_data = Businesses::RankSummary.new(@business.id, params)
    @data = rank_data.fetch
    respond_to do |format|
      format.csv do
        send_data to_csv(@data), filename: "rank_summaries.csv"
      end
      format.json do
        render json: @data.as_json
      end
      format.pdf do
        render pdf: "rank_summaries.pdf",
               print_media_type: true
      end
    end
  rescue ActiveRecord::StatementInvalid
    render json: { status: 500,
                   errors: 'Failed to get rank summary' }
  end

  def to_csv(data)
    CSV.generate(headers: true) do |csv|
      csv << CSV_HEADERS
      data.each do |keyword_data|
        csv << [keyword_data[:keyword], keyword_data[:rank]]
      end
    end
  end

  private

  def set_business
    @business = Business.find(params[:business_id])
  end
end
