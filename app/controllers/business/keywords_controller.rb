class Business::KeywordsController < Business::BaseController
  before_action :split_keywords, only: :create

  def index
    if current_user.normal?
      current_business.update(keywords_last_viewed_at: Time.current)
    end

    @keywords =
      current_business.semrush_keywords.with_ranking.search(
        params[:search_term]
      ).order(order_query).paginate(
        page: params[:page].presence || 1,
        per_page: params[:per_page].presence || 50
      )

    @order = params[:order].eql?('DESC') ? 'ASC' : 'DESC'
  end

  def create
    @resp = Semrush.add_keyword_to_project(current_business.semrush_project_id,
      @keywords)

    flash[:notice] = if @resp.eql?(200)
      "Keywords Added Successfully."
                     else
      "An Error Occured."
                     end
  end

  def keyword_suggestions
    @keywords = Semrush.related_keywords(params[:keyword])
  end

  private

  def order_query
    order = params[:order] || 'DESC'
    order_by = params[:order_by] || 'last_day_google_change'

    "#{order_by} #{order} NULLS LAST"
  end

  def split_keywords
    @keywords = []
    params[:keywords].split("\r\n").each do |keyword|
      keyword_hash = {}
      keyword_hash["keyword"] = keyword
      @keywords << keyword_hash
    end
  end

end
