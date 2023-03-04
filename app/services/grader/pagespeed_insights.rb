# frozen_string_literal: true

module Grader
  class PagespeedInsights < ::ActiveType::Object
    include GoogleInsights

    attribute :url, :string
    attribute :strategy, :string
    attribute :score, :integer
    attribute :results
    attribute :metadata
    attribute :grader_report_id, :integer
    attribute :created_at, :datetime, default: proc { Time.current }
    attribute :updated_at, :datetime

    validates :url, :strategy, :grader_report_id, presence: true
    validates :strategy, inclusion: { in: %w[desktop mobile] }

    before_save do
      self.updated_at = Time.current
    end

    after_save do
      grader_report.update_attributes("#{strategy}_insights": attributes)
    end

    def initialize(attributes)
      super attributes
      set_page_data if updatable?
    end

    private

    def updatable?
      (updated_at || 2.months.ago) < 1.month.ago
    end

    def set_page_data
      @_page_data = get_insights(url, strategy)
      return false if @_page_data.blank? || @_page_data.fetch('error', nil).present?

      self.metadata = @_page_data
      self.score =
        @_page_data['lighthouseResult']['categories']['performance']['score'] * 100
      self.results = audit_results(strategy)
      save
    end

    def grader_report
      @_grader_report ||= GraderReport.find(grader_report_id)
    end

    def insights_audits_keys strategy
      categories = @_page_data['lighthouseResult']['categories']
      categories['performance']['auditRefs'].map do |ref|
        next unless %w[diagnostics opportunities].include?(ref['group'])

        ref['id']
      end.compact.uniq
    end

    def insights_audits strategy
      audits = @_page_data['lighthouseResult']['audits']
      #audits.slice(*insights_audits_keys(strategy))
    rescue
      {}
    end

    def audit_results strategy
      insights_audits(strategy).map do |key, audit|
        {
          pass: audit['score'].eql?(1),
          rule: audit['title']
        }
      end
    end
  end
end
