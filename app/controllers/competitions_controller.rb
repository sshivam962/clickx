# frozen_string_literal: true

class CompetitionsController < ApplicationController
  before_action -> { stub_with_dummy_data(key: 'competition') }, only: :show
  before_action -> { stub_with_dummy_data(key: 'potential_competitors') }, only: :potential_competitors
  before_action :set_competition,
                only: %i[show destroy
                         competition_keywords export_backlinks_csv
                         export_top_pages_csv export_keywords_organic_csv
                         export_keywords_adwords_csv competitors_history ]
  before_action -> { authorize @competition.business, :client_level_manage? },
                only: %i[show destroy
                         competition_keywords export_backlinks_csv
                         export_top_pages_csv export_keywords_organic_csv
                         export_keywords_adwords_csv]
  before_action :set_business,
                only: %i[potential_competitors
                         common_backlinks potential_keywords business_competitions
                         export_competitors_csv]
  before_action -> { authorize @business, :client_level_manage? },
                only: %i[potential_competitors common_backlinks
                         potential_keywords business_competitions
                         export_competitors_csv]
  before_action :set_competition_data,
                only: %i[business_competitions export_competitors_csv]
  def show
    @competition.competition_update_job if @competition.updatable?
    @competition.backlinks = @competition.backlinks.presence || []
    @competition.top_pages = @competition.top_pages.presence || []
    @competition.keywords_organic = @competition.keywords_organic.presence || []
    @competition.keywords_adwords = @competition.keywords_adwords.presence || []
    @competition.anchor_text_data = @competition.anchor_text_data.presence || []
    render json: { competition: @competition }, status: :ok
  rescue StandardError
    head :not_acceptable
  end

  def create
    @competition = Competition.new(competition_params)
    if @competition.save

      CompetitorMailer.competitor_added(@competition, current_user).deliver_later
      render json: { competition: @competition }, status: :ok
    else
      render json: { competition: @competition,
                     errors: @competition.errors.full_messages.to_sentence },
             status: :unprocessable_entity
    end
  end

  def destroy
    if @competition.destroy
      render json: { status: 200 }
    else
      render json: { status: 406 }
    end
  end

  def business_competitions
    @competitions = @competitions_data.map { |competitions| CompetitorsPresenter.new(competitions) }
    respond_to do |format|
      format.pdf do
        render pdf: "business_competition.pdf",
               print_media_type: true
      end
      format.json do
        render json: { data: @competitions_data, total_count: @total_count }
      end
    end
  end

  def competitors_history
    @competitors_traffic_history = [
      domain_traffic_history(@competition.domain_host, '#60BBEA')
    ]
    render json: { data: @competitors_traffic_history }
  end

  def competition_keywords
    @domain = DomainRanking.where('domain LIKE ? ', @competition.summary['Item'])
    if @domain
      render json: @domain
    else
      render json: { message: @domain.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def potential_competitors
    render json: @business.potential_competitors
  end

  def common_backlinks
    render json: @business.backlinks_to_competitors
  end

  def potential_keywords
    render json: @business.potential_keywords
  end

  def export_backlinks_csv
    send_data @competition.backlinks_to_csv, disposition: 'attachment', filename: "backlinks_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_top_pages_csv
    send_data @competition.top_pages_to_csv, disposition: 'attachment', filename: "top_pages_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_keywords_organic_csv
    send_data @competition.keywords_organic_to_csv, disposition: 'attachment', filename: "keywords_organic_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_keywords_adwords_csv
    send_data @competition.keywords_adwords_to_csv, disposition: 'attachment', filename: "keywords_adwords_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_competitors_csv
    competitions = JSON.parse(@competitions_data.to_json)
    csv_data = CSV.generate do |csv|
      csv << competitions.first.keys
      competitions.each do |data|
        csv << data.values
      end
    end
    send_data csv_data, disposition: 'attachment', filename: "competitiors_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  private

  def set_competition_data
    @business.competitions
             .where('updated_at < ?', 7.days.ago)
             .map(&:competition_update_job)
    @competitions = @business.competitions
                             .select(:id, :name, :business_id, :logo)
                             .order(:name)
    @total_count = @business.competitions.count
    params[:offset] = params[:offset] || 1
    params[:limit] = params[:limit] || @business.competitions.count
    # Reverse engineered the formula from here
    # https://stackoverflow.com/a/3521002/1749638
    #
    page = ((params[:offset].to_i - 1)/params[:limit].to_f).ceil + 1

    @competitions_data = @competitions.search(params[:name]).page(page).per_page(params[:limit].to_i)
  end

  def set_competition
    @competition = Competition.find(params[:id])
    @business = Business.with_dummy.find(@competition.business_id)
  end

  def set_business
    @business = Business.with_dummy.find(params[:business_id])
  end

  def competition_params
    params.require(:competition).permit(:id, :name, :business_id)
  end

  def domain_traffic_history(domain, color)
    traffic_history = Semrush.domain_traffic_history(domain).reverse
    chart_data = traffic_history.map { |t| [t[:date], t[:organic_traffic]] }
    { name: domain, data: chart_data, marker: { enabled: false }, color: color }
  end
end
