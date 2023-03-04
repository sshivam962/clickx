# frozen_string_literal: true
module SearchTerms
  class IndexView
    attr_accessor :keywords
    attr_reader :params

    DEFAULT_PER_PAGE = 10
    DEFAULT_SORTING = { updated_at: :desc }.freeze

    SORTABLE_FIELDS = %i[name city locale].freeze

    def initialize(business, params)
      @params = params
      @keywords = business&.search_terms || []
      process
    end

    def to_json
      {
        data: {
          search_terms: keywords,
          total_pages: keywords.total_pages
        }
      }
    end

    private

    def process
      sort_keywords
      process_search
      paginate
    end

    def paginate
      self.keywords =
        if params[:page]
          keywords.page(params[:page][:number].to_i || 1)
                  .per_page(params[:page][:size].to_i || DEFAULT_PER_PAGE)
        else
          keywords.page(1).per_page(DEFAULT_PER_PAGE)
        end
    end

    def sort_keywords
      if params[:sort]
        sort_params = SortParams.sorted_fields(params[:sort], SORTABLE_FIELDS, DEFAULT_SORTING)
        self.keywords = keywords.order(sort_params)
      else
        self.keywords = keywords.order(created_at: :desc)
      end
    end

    def process_search
      if params[:search].present?
        self.keywords = keywords
                        .where('name ILIKE :query OR city ILIKE :query',
                               query: "%#{params[:search]}%")
      end
    end
  end
end
