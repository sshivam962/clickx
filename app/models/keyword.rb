# frozen_string_literal: true

class Keyword < KeywordBase
  has_many :taggables
  has_many :keyword_tags, through: :taggables
  has_many :keyword_rankings, dependent: :delete_all

  acts_as_taggable_on :tags
  acts_as_paranoid

  after_destroy :add_keyword_from_wishlist, if: :active?

  before_save on: :create do
    self.active = business.keywords.active.count <= business.keyword_limit
    self.locale ||= business.locale
    self.city ||= business.target_city
  end

  after_save :update_keyword_data_if_location_changed

  after_create :queue_for_ranking, if: :active?
  after_save :delete_keyword_rankings

  scope :active, -> { where(active: true) }
  scope :wishlist, -> { where(active: false) }
  scope :latest, -> { order('updated_at ASC') }
  # after_create :set_kdi, if: -> { Rails.env.production? && kdi_updatable? }

  def self.to_csv
    attributes = %w[name city]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |rankings|
        csv << attributes.map { |attr| rankings.send(attr) }
      end
    end
  end

  def update_keyword_data_if_location_changed
    if saved_change_to_city? || saved_change_to_locale?
      keyword_rankings.destroy_all
      queue_for_ranking
    end
  end

  def delete_keyword_rankings
    keyword_rankings.destroy_all if saved_change_to_city? || saved_change_to_locale?
  end

  def city
    super.presence || business.target_city
  end

  def locale
    super.presence || business.locale
  end

  def self.search(search_term)
    search_term ||= ''
    where('lower(name) like ?', "%#{search_term.downcase}%")
  end

  def add_keyword_from_wishlist
    Keyword.check_for_limit_changes(business_id) unless destroyed_by_association
  end

  def self.check_for_limit_changes(business_id)
    keyword_limit = Business.find(business_id).keyword_limit
    difference = keyword_limit - active.where(business_id: business_id).count
    if difference.positive? # keywords limit upgraded
      wishlist.where(business_id: business_id).latest.limit(difference).update_all(active: true)
    elsif difference.negative? # keywords limit degraded
      active.where(business_id: business_id).latest.limit(difference.abs).update_all(active: false)
    end
  end

  def set_kdi
    self.kdi = Semrush.keyword_difficulty(name)[:keyword_difficulty] || -1
    self.kdi_updated_at = Time.current
    save
  end

  def kdi_updatable?
    (kdi_updated_at || 2.years.ago) < 1.year.ago
  end

  private

  def queue_for_ranking
    if (Rails.env.production? || Rails.env.staging?) && active?
      keyword_rankings.first_or_dup_on(rank_date: Date.current).save
      AddToPriorityQueueJob.perform_async(name, 'google', city, 'keyword_ranking', locale)
    end
  end
end
