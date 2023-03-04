class Business::KeywordsGeneratorController < Business::BaseController
  def index;end

  def generate
    @keywords = []

    params[:keywords].each do |k|
      @keywords.push(k.split("\r\n")) if k.present?
    end

    @generated_keywords = KeywordsGenerator.generate_combinations(@keywords)
  end

  def keyword_suggestions
    @keywords = Semrush.related_keywords(params[:keyword])
  end

  def create
    @keywords = params[:keywords].split("\r\n").map(&:strip).select(&:present?)

    city = params[:city]&.downcase
    locale = params[:locale]

    @keywords&.each do |keyword|
      if current_business.keywords.active.count >= current_business.keyword_limit
        @error = 'Keyword Limit Exceeded, Delete Keywords or Upgrade your plan.'
        break
      end

      deleted_keyword = current_business.keywords.only_deleted.find_by(
        name: keyword, locale: locale, city: city
      )

      @keyword =
        if deleted_keyword.present?
          deleted_keyword.restore
        else
          current_business.keywords.create(
            name: keyword, locale: locale, city: city
          )
        end

      @errors = []

      if @keyword.errors.any?
        @errors.push(
          @keyword.errors.full_messages.to_sentence.gsub('Name', keyword.name)
        )
      end
    end

    if @errors.empty?
      @success = 'Keywords Added Successfully.'
    end
  end
end
