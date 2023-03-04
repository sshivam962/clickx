# frozen_string_literal: true

module Adwords
  module Graph
    class Base
      attr_accessor :client_id, :cost_markup, :campaign_ids, :start_date,
                    :end_date, :start_last_period, :end_last_period, :chart_type,
                    :business, :type

      VALID_TYPES = %w[adword].freeze

      def self.from_params(business, params, type: 'adword')
        business = business
        chart_type = params[:chart_type] || 'default'
        start_date = params[:start_date] || (Date.today - 29.days).strftime('%Y%m%d')
        end_date = params[:end_date] || Date.today.strftime('%Y%m%d')
        time_gap = (end_date.to_date - start_date.to_date).to_i + 1
        if (end_date.to_date.strftime('%d') == Time.zone.now.strftime('%d')) &&
           (start_date.to_date.strftime('%d') == '01')
          start_last_period = end_date.to_date.prev_month.beginning_of_month.strftime('%Y%m%d')
          end_last_period = start_last_period.to_date.end_of_month.strftime('%Y%m%d')
        else
          start_last_period = (start_date.to_date - time_gap.to_i.days).strftime('%Y%m%d')
          end_last_period = (start_date.to_date - 1.day).strftime('%Y%m%d')
        end
        new(business.id, start_date, end_date, start_last_period, end_last_period, chart_type, type: type).fetch
      end

      def initialize(business_id, start_date, end_date, start_last_period, end_last_period, chart_type, type:, markup_applied: true)
        raise 'Invalid type' unless VALID_TYPES.include?(type)
        @business = Business.find(business_id)
        @start_date = start_date
        @end_date = end_date
        @start_last_period = start_last_period
        @end_last_period = end_last_period
        @chart_type = chart_type
        @type = type
        if type == 'adword'
          @client_id = business.adword_client_id
          @cost_markup = markup_applied ? business.adword_cost_markup.to_i : 0
          @campaign_ids = business.adword_campaign_ids
        end
        @this_period = {}
        @last_period = {}
        @total_details = []
      end

      def self.fetch(*args)
        new(*args).fetch
      end

      private

      def current_data
        @_current_data ||= adword_client.send_query(query, start_date, end_date)
      end

      def adword
        @_adword ||= Adwords.get_adword(client_id, business)
      end

      def adword_client
        @_adword_client ||= Adwords::Adword.new(business, client_id, type)
      end
    end
  end
end
