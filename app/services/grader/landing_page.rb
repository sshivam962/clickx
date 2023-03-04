# frozen_string_literal: true

module Grader
  class LandingPage < ::ActiveType::Object
    attribute :url, :string
    attribute :title, :string
    attribute :description, :string
    attribute :valid_title, :boolean
    attribute :valid_description, :boolean
    attribute :ssl_enabled, :boolean
    attribute :social_links
    attribute :links_empty, :boolean
    attribute :score, :integer
    attribute :valid_h1, :boolean
    attribute :h1_count, :integer
    attribute :h1_contents

    attribute :grader_report_id, :integer
    attribute :created_at, :datetime, default: proc { Time.current }
    attribute :updated_at, :datetime

    validates :url, :grader_report_id, presence: true

    NETWORKS = %i[twitter facebook google_plus linkedin youtube pinterest instagram].freeze

    before_save do
      self.updated_at = Time.current
    end

    after_save do
      grader_report.update_attributes(landing_page: attributes)
    end

    def initialize(attributes)
      super attributes
      set_landing_page_data if updatable?
    end

    private

    def updatable?
      (updated_at || 2.months.ago) < 1.month.ago
    end

    def set_landing_page_data
      begin
        @_meta_inspect ||= MetaInspector.new(url)
      rescue FaradayMiddleware::RedirectLimitReached
        return false
      rescue MetaInspector::ParserError
        return false
      rescue MetaInspector::RequestError
        return false
      end
      @_meta_data ||= @_meta_inspect.to_hash

      begin
        doc = Nokogiri::XML(open(@_meta_inspect.url))
      rescue OpenURI::HTTPError
        return false
      end

      self.h1_contents = doc.css('h1').map(&:text).select(&:present?) || []
      self.h1_count = h1_contents.count
      self.valid_h1 = h1_count == 1

      self.title = get_existing(
        [@_meta_data['title'], @_meta_data['best_title']]
      )
      self.valid_title = title.to_s.size.between?(50, 60)

      self.description = get_existing(
        [@_meta_data['description'], @_meta_data['best_description']]
      )
      self.valid_description = description.to_s.size.between?(150, 160)

      self.ssl_enabled = @_meta_data['scheme'].eql?('https')

      links = doc.css('a').map do |x|
        x['href'] if valid_url?(x['href'])
      end.compact
      self.social_links = parse_social_links(links)
      self.links_empty = social_links.blank?
      self.score = calculate_score

      save
    end

    def valid_url?(uri)
      uri = URI.parse(uri)
      !uri.host.nil?
    rescue URI::InvalidURIError, URI::InvalidComponentError
      false
    end

    def get_existing(texts)
      texts.keep_if(&:present?).first
    end

    def parse_social_links(links)
      return [] if links.blank?

      ids = IdsPlease.new links
      ids.recognize
      recognized_links = ids.recognized
      recognized_links.keep_if { |k, _| NETWORKS.include? k }
      recognized_links.map { |k, _v| recognized_links[k] = recognized_links[k].map(&:to_s).map { |val| val.sub(/(\/)+$/, '') }.sort }
      recognized_links.map do |k, v|
        domain = "#{k}.com"
        recognized_links[k] = v.map do |l|
          l unless l[(l.size - domain.size)..-1].eql?(domain)
        end.compact.first
      end
      recognized_links
    end

    def calculate_score
      title_score = valid_title ? 1 : 0
      description_score = valid_description ? 1 : 0
      ssl_score = ssl_enabled ? 1 : 0
      social_links_score = social_links.count

      total = title_score + description_score + ssl_score + social_links_score
      ((total / 10.0) * 100).to_i # 1+1+1+7 = 10
    end

    def grader_report
      @_grader_report ||= GraderReport.find(grader_report_id)
    end
  end
end
