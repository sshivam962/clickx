# frozen_string_literal: true
class SearchTermsController < ApplicationController
  before_action :set_search_term, only: %i[show destroy]

  def create
    @search_term = current_business.search_terms.create(keyword_params)
    if @search_term.persisted?
      render json: { status: 200, message: 'success' }
    else
      render json: { status: 401,
                     message: @search_term.errors.full_messages.to_sentence }
    end
  end

  def index
    @search_term_view = SearchTerms::IndexView.new(current_business, params)
    render json: @search_term_view.to_json
  end

  def show
    respond_to do |format|
      format.csv do
        send_data to_csv(@search_term.latest_rankings), filename: 'ranking_positions.csv'
      end
      format.pdf do
        render pdf: "ranking_positions.pdf",
               print_media_type: true
      end
      format.json do
        render json: { status: 200,
                       data: {
                         search_term: @search_term,
                         latest_rankings: @search_term.latest_rankings
                       } }
      end
    end
  end

  def destroy
    if @search_term.destroy
      render json: { status: 200, message: 'success' }
    else
      render json: { status: 401,
                     message: @search_term.errors.full_messages.to_sentence }
    end
  end

  private

  def set_search_term
    @search_term = SearchTerm.find(params[:id])
  end

  def keyword_params
    params.require(:keyword).permit(:name, :city, :locale)
  end

  def to_csv(data)
    attributes_names = %w[Title Link Description CurrentPositionRanking Last7Days Last14Days Last30Days]
    attributes = %w[title href description rank last_7_days last_14_days last_30_days]

    CSV.generate(headers: true) do |csv|
      csv << attributes_names
      data.each do |ranking|
        csv << ranking.attributes.values_at(*attributes)
      end
    end
  end
end
