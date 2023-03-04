# frozen_string_literal: true

class Competition < ApplicationRecord
  validates :name, :business_id, presence: true
  validates :name, url: true, on: :create
  validates :name, uniqueness: { scope: :business_id }
  after_create :set_logo_url, :competition_update_job, :delete_cache
  belongs_to :business
  validate :domain_duplicity_check, :competition_count_within_limit, on: :create
  before_validation :format_url
  scope :search, (lambda do |name|
    name ? where("lower(name) ILIKE '%#{name.downcase}%'") : all
  end)

  def domain_duplicity_check
    return false unless name and business_id
    @business = Business.with_dummy.find(business_id)
    host = URI.parse(name).host || URI.parse("http://#{name}").host
    domain = PublicSuffix.domain(host)
    self.name = domain
    if !domain
      false
    elsif @business.competitions.where(name: domain).count.positive?
      errors.add(:name, 'Competition already exists')
      false
    else
      true
    end
  end

  def format_url
    self.name = /(?:(https?:\/\/)?)(?:(www\.)?)(.*\..*)/.match(name.downcase)[3]
    self.name = "http://#{name}"
  rescue => e
    self.errors.add(:base, 'Invalid URL')
    throw(:abort)
  end

  def self.name_format(name)
    name = /(?:(https?:\/\/)?)(?:(www\.)?)(.*\..*)/.match(name.downcase)[3]
    "http://#{name}"
  end

  def competition_count_within_limit
    errors.add(:base, 'Sorry! Competitors limit exceeded. Please contact your account manager to upgrade your plan.') if business.competitions.reload.count > (business.competitors_limit - 1)
  end

  def competition_update_job
    return if business.dummy?
    CompetitionUpdateJob.perform_later(self)
  end

  def update_competition
    # summary = Majestic.get_backlink_summary(name)
    # backlinks = begin
    #               Majestic.get_backlinks(name)
    #             rescue StandardError
    #               []
    #             end
    # top_pages = begin
    #               Majestic.get_top_pages(name)
    #             rescue StandardError
    #               []
    #             end
    # anchor_text = begin
    #                 Majestic.get_anchor_text_chart_data(name)
    #               rescue StandardError
    #                 {}
    #               end
    keywords_organic = begin
                         Semrush.organic_keywords(domain_host)
                       rescue StandardError
                         []
                       end
    keywords_adwords = begin
                         Semrush.adwords_keywords(domain_host)
                       rescue StandardError
                         []
                       end
    # anchor_text_data = begin
    #                      Majestic.get_anchor_text(name)
    #                    rescue StandardError
    #                    end
    update_attributes(
      keywords_organic: keywords_organic,
      keywords_adwords: keywords_adwords,
      # summary: summary,
      # backlinks: backlinks,
      # top_pages: top_pages,
      # anchor_text: anchor_text,
      # anchor_text_data: anchor_text_data,
      updated_at: Time.current
    )
  end

  def backlinks_to_csv
    attributes = %w[SourceURL ACRank AnchorText Date FlagRedirect FlagFrame FlagNoFollow FlagImages FlagDeleted FlagAltText FlagMention TargetURL DomainID FirstIndexedDate LastSeenDate DateLost ReasonLost LinkType LinkSubType TargetCitationFlow TargetTrustFlow TargetTopicalTrustFlow_Topic_0 TargetTopicalTrustFlow_Value_0 SourceCitationFlow SourceTrustFlow SourceTopicalTrustFlow_Topic_0 SourceTopicalTrustFlow_Value_0]

    to_csv 'backlinks', attributes
  end

  def top_pages_to_csv
    attributes = %w[ACRank URL Title ExtBackLinks RefDomains]

    to_csv 'top_pages', attributes
  end

  def keywords_organic_to_csv
    attributes = %w[keyword position search_volume cpc traffic]
    to_csv 'keywords_organic', attributes
  end

  def keywords_adwords_to_csv
    attributes = %w[keyword position search_volume cpc traffic]
    to_csv 'keywords_adwords', attributes
  end

  def to_csv(field, attributes)
    CSV.generate(headers: true) do |csv_data|
      csv_data << attributes
      send(field.to_s).each do |keyword|
        csv_row = keyword.values_at(*attributes)
        csv_data << csv_row
      end
    end
  end

  def set_logo_url
    return if business.dummy?
    FetchCompetitorLogoJob.perform_now(self)
  end

  def delete_cache
    Rails.cache.delete("#{business.cache_key}/potential_competitions")
  end

  def info_missing?
    # summary['ExtBackLinks'].to_i.zero? ||
    #   summary['RefDomains'].to_i.zero? ||
    #   summary['CitationFlow'].to_i.zero? ||
    #   summary['TrustFlow'].to_i.zero? ||
    #   backlinks.blank? ||
    #   top_pages.blank? ||
    #   anchor_text_data.blank?

    keywords_organic.blank? || keywords_adwords.blank?
  end

  def updatable?
    info_missing? || updated_at < 7.days.ago
  end

  def domain_host
    Addressable::URI.parse(name).host
  rescue StandardError
    nil
  end
end
