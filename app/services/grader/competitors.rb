# frozen_string_literal: true

module Grader
  class Competitors < ::ActiveType::Object
    attribute :url, :string
    attribute :ctype, :string
    attribute :competitors

    attribute :grader_report_id, :integer
    attribute :created_at, :datetime, default: proc { Time.current }
    attribute :updated_at, :datetime

    validates :url, :grader_report_id, presence: true
    validates :ctype, inclusion: { in: %w[organic adwords] }

    before_save do
      self.updated_at = Time.current
    end

    after_save do
      grader_report.update_attributes("#{ctype}_competitors": attributes)
    end

    def initialize(attributes)
      super attributes
      set_competitors_data if updatable?
    end

    private

    def updatable?
      (updated_at || 2.months.ago) < 1.month.ago
    end

    def set_competitors_data
      self.competitors = Semrush.public_send("competitors_#{ctype}", url)
      save
    end

    def grader_report
      @_grader_report ||= GraderReport.find(grader_report_id)
    end
  end
end
