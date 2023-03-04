# frozen_string_literal: true

module Grader
  class Backlinks < ::ActiveType::Object
    include Majestic

    attribute :url, :string
    attribute :score, :integer

    attribute :trust_flow, :integer
    attribute :citation_flow, :integer
    attribute :ext_backlinks, :integer
    attribute :ref_domains, :integer
    attribute :backlinks

    attribute :grader_report_id, :integer
    attribute :created_at, :datetime, default: proc { Time.current }
    attribute :updated_at, :datetime

    validates :url, :grader_report_id, presence: true

    before_save do
      self.updated_at = Time.current
    end

    after_save do
      grader_report.update_attributes(backlinks: attributes)
    end

    def initialize(attributes)
      super attributes
      set_backlinks_data if updatable?
    end

    private

    def updatable?
      url.present? && (updated_at || 2.months.ago) < 1.month.ago
    end

    def grader_report
      @_grader_report ||= GraderReport.find(grader_report_id)
    end

    def set_backlinks_data
      @_summary ||= get_backlink_summary url
      @_backlinks ||= get_backlinks url, 5

      set_backlinks_summary
      set_backlinks
      calculate_score

      save
    end

    def set_backlinks_summary
      self.trust_flow = @_summary['TrustFlow']
      self.citation_flow = @_summary['CitationFlow']
      self.ext_backlinks = @_summary['ExtBackLinks']
      self.ref_domains = @_summary['RefDomains']
    end

    def set_backlinks
      self.backlinks = @_backlinks.map do |b|
        { topic: choose_topic([b['SourceTopicalTrustFlow_Topic_0'],
                               b['SourceTopicalTrustFlow_Topic_1'],
                               b['SourceTopicalTrustFlow_Topic_2']]),
          anchor_text: b['AnchorText'],
          source_url: b['SourceURL'],
          target_url: b['TargetURL'] }
      end
    end

    def calculate_score
      self.score = case (trust_flow + citation_flow) / 2
                   when 0 then 0
                   when 1..10 then 15
                   when 10..20 then 40
                   when 20..40 then 65
                   else 85
                   end
    end

    def choose_topic(topics)
      topics.keep_if(&:present?).first
    end
  end
end
