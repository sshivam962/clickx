# frozen_string_literal: true

module CommonReportScopes
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.instance_eval do
      scope :on, ->(date) { where(report_date: date) }
      scope :yesterday, -> { on(Date.yesterday) }

      scope :between, ->(start_date, end_date) {
        where('report_date >= ? AND report_date <= ?',
              start_date, end_date)
      }

      scope :last_7_days, -> { between(7.days.ago, Date.today) }
      scope :last_30_days, -> { between(30.days.ago, Date.today) }

      type = klass.name.tableize.split('_').first
      report_fields_1 = "#{type}_id, #{type}_name, #{type}_type"
      report_fields_2 = 'report_date'

      columns = %w[impressions clicks costs revenue]
      query_1 = report_fields_1 + ',' + columns.map { |c| "SUM(#{c}) AS #{c}" }.join(',')
      query_2 = report_fields_2 + ',' + columns.map { |c| "SUM(#{c}) AS #{c}" }.join(',')

      scope :aggregate, -> { group(report_fields_1).select(query_1).map(&:attributes) }
      scope :aggregate_by_date, -> { group(report_fields_2).select(query_2).order(:report_date).map(&:attributes) }
    end
  end
end
