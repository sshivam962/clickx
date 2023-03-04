module SuperAdmin
  module AgencyFilterManager
    extend ActiveSupport::Concern

    included do
      before_action :set_filters, only: [:index, :agency_sheet]

      private

      def filter_query
        return '' if @filter_name.blank? && @filter_label.blank? && @filter_status.blank?

        q = []
        if @filter_name.present?
          q.push("(lower(agencies.name) ILIKE '%#{@filter_name}%' OR lower(users.email) ILIKE '%#{@filter_name}%' OR CONCAT_WS(' ', lower(users.first_name), lower(users.last_name)) ILIKE '%#{@filter_name}%')")
        end
        if @filter_label.present?
          if @filter_label.downcase == "scale"
            q.push("agencies.scale_program =  true")
          else
            q.push("agencies.labels ILIKE '%#{@filter_label.downcase}%'")
          end
        end
        if @filter_status.present?
          q.push("agencies.agency_status =  #{@filter_status}")
        end
        q.join(' AND ')
      end

      def set_filters
        set_cookie(:agency_filters, {}) if get_cookie(:agency_filters).blank?

        @filter_name = params[:name]
        @filter_label = params[:label]
        @filter_status = params[:status]
        @filter_is_paid = params[:is_paid]

        @filter_name ||= get_cookie(:agency_filters)['name']
        @filter_label ||= get_cookie(:agency_filters)['label']
        @filter_status ||= get_cookie(:agency_filters)['status']
        @filter_is_paid ||= get_cookie(:agency_filters)['is_paid']

        set_cookie(:agency_filters, {
          name: @filter_name, label: @filter_label, status: @filter_status, is_paid: @filter_is_paid
        })
      end
    end
  end
end
