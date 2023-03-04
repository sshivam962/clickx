module AgencyCaseStudyManager
  extend ActiveSupport::Concern

  included do

    before_action :set_filters
    
    private

    def filter_query_industry
      return '' if @filter_q.blank?

      q = []
      if @filter_q.present?
        q.push("(lower(industries.title) ILIKE '%#{@filter_q}%')")
      end
      q.join(' AND ')
    end

    def filter_query_case_study
      return '' if @filter_q.blank?

      q = []
      if @filter_q.present?
        q.push("(lower(case_studies.title) ILIKE '%#{@filter_q}%')")
      end
      q.join(' AND ')
    end

    def set_filters
      set_cookie(:agency_case_study_filters, {}) if get_cookie(:agency_case_study_filters).blank?

      if request.xhr?
        @filter_q = params[:q]
      else
        @filter_q ||= get_cookie(:agency_case_study_filters)['q']
      end

      set_cookie(:agency_case_study_filters, {q: @filter_q})
    end
  end
end