module SuperAdmin
  module ClientQueryBuilder
    extend ActiveSupport::Concern

    included do
      before_action :set_filters, only: :index

      private

      def search_query
        return '' if @filter_name.blank?

        "lower(businesses.name) ILIKE '%#{@filter_name}%' OR lower(businesses.domain) ILIKE '%#{@filter_name}%' OR lower(businesses.unique_id) ILIKE '#{@filter_name}'"
      end

      def filter_query
        [
          agencies_query,
          agency_white_labeled_query,
          services_query
        ].select(&:present?).join(' AND ')
      end

      def services_query
        return '' if @filter_services.blank?

        q = []
        @filter_services.each do |service|
          q.push("#{service} = TRUE")
        end
        q.join(' OR ')
      end

      def agencies_query
        return '' if @filter_agencies.blank?

        "businesses.agency_id IN (#{@filter_agencies.join(',')})"
      end

      def agency_white_labeled_query
        return '' if @filter_agency_white_labeled.blank?

        "agencies.white_labeled = TRUE"
      end

      def set_filters
        set_cookie(:client_filters, {}) if get_cookie(:client_filters).blank?
        if request.xhr?
          @filter_name = params[:name]
          @filter_services = params[:services]
          @filter_agencies = params[:agencies]
          @filter_labels = params[:labels]
          @filter_agency_white_labeled = params[:agency_white_labeled].present?
        else
          @filter_name ||= get_cookie(:client_filters)['name']
          @filter_services ||= get_cookie(:client_filters)['services']
          @filter_agencies ||= get_cookie(:client_filters)['agencies']
          @filter_labels ||= get_cookie(:client_filters)['labels']
          @filter_agency_white_labeled ||=
            get_cookie(:client_filters)['agency_white_labeled']
        end

        set_cookie(:client_filters, {
          name: @filter_name,
          labels: @filter_labels,
          services: @filter_services,
          agencies: @filter_agencies,
          agency_white_labeled: @filter_agency_white_labeled
        })
      end
    end
  end
end
