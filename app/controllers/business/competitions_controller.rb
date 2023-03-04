class Business::CompetitionsController < Business::BaseController
  before_action :set_competition, only: %i[show destroy export_top_pages_csv export_keywords_organic_csv export_keywords_paid_csv organic_keywords paid_keywords fresh_backlinks export_backlinks_csv all_backlinks anchor_text export_anchor_texts_csv competitors_rank]
  before_action :set_export_data, only: %i[export_pdf export_csv]

  def index
    @competitions =
      current_business
        .competitions
        .search(params[:name])
        .order(:name)
        .paginate(
          page: params[:page].presence || 1,
          per_page: params[:per_page].presence || 5
        )
  end

  def create
    @competition = current_business.competitions.new(competition_params)
    if @competition.save
      CompetitorMailer.competitor_added(@competition, current_user).deliver_later
    end
  end

  def show
    # @competitors_traffic_history = [
    #   domain_traffic_history(@competition.domain_host, '#60BBEA')
    # ]
    # @backlinks_summary = @competition.summary
    # @top_pages = @competition.top_pages.map { |page| TopPagesPresenter.new(page) }.presence || []
    @keywords_organic = @competition.keywords_organic.map { |keyword| KeywordsOrganicPresenter.new(keyword) }.presence || []
    @keywords_paid = @competition.keywords_adwords.map { |keyword| KeywordsPaidPresenter.new(keyword) }.presence || []
  end

  def organic_keywords
    @business_keywords = current_business.keywords.pluck(:name)
    @keywords = @competition.keywords_organic.map { |keyword|KeywordsOrganicPresenter.new(keyword) }.select {|k| k.name.include?(params[:keyword].presence || '')}.paginate(page: params[:page], per_page: 30)
  end

  def paid_keywords
    @business_keywords = current_business.keywords.pluck(:name)
    @keywords = @competition.keywords_adwords.map { |keyword|KeywordsPaidPresenter.new(keyword) }.select {|k| k.name.include?(params[:keyword].presence || '')}.paginate(page: params[:page], per_page: 30)
  end

  def add_keyword
    @errors = []

    if current_business.keywords.active.count >= current_business.keyword_limit
      @errors.push('Keyword Limit Exceeded, Delete Keywords or Upgrade your plan.')
      render json: { status: 406, error: @errors.join(', ')
      }
      return
    end

    @keyword_name = params[:keyword]
    deleted_keyword = current_business.keywords.only_deleted.find_by(
      name: @keyword_name
    )

    @keyword =
      if deleted_keyword.present?
        deleted_keyword.restore
      else
        current_business.keywords.create(
          name: @keyword_name
        )
      end

    if @keyword.errors.any?
      @errors.push(
        @keyword.errors.full_messages.to_sentence.gsub('Name', @keyword_name)
      )
    end

    if @errors.present?
      render json: { status: 406, error: @errors.join(', ')
      }
    else
      render json: { status: 201 }
    end
  end

  def remove_keyword
    keyword = params[:keyword]
    @keyword = current_business.keywords.find_by(name: keyword)

    if @keyword.present?
      @keyword.destroy
      render json: { status: 204 }
    else
      render json: { error: 'Keyword Not Found.' }
    end
  end

  def fresh_backlinks
    @backlinks = @competition.backlinks.map { |backlink| BacklinksPresenter.new(backlink) }.presence || []
  end

  def all_backlinks
    @all_backlinks = @competition.backlinks.map { |backlink| BacklinksPresenter.new(backlink) }
    @backlinks = @all_backlinks.paginate(page: params[:page], per_page: 30)
  end

  def anchor_text
    @anchor_texts = (@competition.anchor_text_data || []).first(10).map { |anchor_text| AnchorTextPresenter.new(anchor_text) }.presence || []
  end

  def competitors_rank
    @domain = DomainRanking.where('domain LIKE ? ', @competition.summary['Item'])
  end

  def destroy
    @competition.destroy
  end

  def potential_competitors
    @competitors_organic = current_business.potential_competitors[:organic]
      .paginate(
        page: params[:page].presence || 1,
        per_page: params[:per_page].presence || 20
      )
    @competitors_paid = current_business.potential_competitors[:paid]
      .paginate(
        page: params[:page].presence || 1,
        per_page: params[:per_page].presence || 20
      )
  end

  def export_pdf
    @competitions =
      @competitions.map { |competition| CompetitorsPresenter.new(competition) }
    respond_to do |format|
      format.pdf do
        render(
          pdf: "competitiors_#{Time.now.strftime('%Y%m%d')}",
          print_media_type: true
        )
      end
    end
  end

  def export_csv
    competitions = JSON.parse(@competitions.to_json)
    csv_data = CSV.generate do |csv|
      csv << competitions.first.keys
      competitions.each do |competition|
        csv << competition.values
      end
    end
    send_data(
      csv_data, disposition: 'attachment',
      filename: "competitiors_#{Time.now.strftime('%Y%m%d')}.csv"
    )
  end

  def export_top_pages_csv
    send_data @competition.top_pages_to_csv, disposition: 'attachment', filename: "top_pages_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_keywords_organic_csv
    send_data @competition.keywords_organic_to_csv, disposition: 'attachment', filename: "keywords_organic_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_keywords_paid_csv
    send_data @competition.keywords_adwords_to_csv, disposition: 'attachment', filename: "keywords_adwords_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_backlinks_csv
    send_data @competition.backlinks_to_csv, disposition: 'attachment', filename: "backlinks_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_anchor_texts_csv
    send_data @competition.anchor_text_data, disposition: 'attachment', filename: "anchor_texts_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  private

  def set_export_data
    if params[:all].eql?('true')
      @competitions = current_business.competitions.order(:name)
    else
      @competitions =
        current_business
          .competitions
          .search(params[:name])
          .order(:name)
          .paginate(
            page: params[:page].presence || 1,
            per_page: params[:per_page].presence || 5
          )
    end
  end

  def competition_params
    params.require(:competition).permit(:name)
  end

  def set_competition
    @competition = Competition.find(params[:id])
  end

  def domain_traffic_history(domain, color)
    traffic_history = Semrush.domain_traffic_history(domain).reverse
    chart_data = traffic_history.map { |t| [t[:date], t[:organic_traffic]] }
    { name: domain, data: chart_data, marker: { enabled: false }, color: color }
  end

end
