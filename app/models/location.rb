# frozen_string_literal: true

class Location < ApplicationRecord
  include BrightLocal
  extend FriendlyId
  obfuscatable
  friendly_id :slug_candidates, use: %i[slugged history]

  has_many :social_links, dependent: :delete_all
  has_many :review_links, dependent: :delete_all
  belongs_to :user, optional: true
  belongs_to :business, -> { with_deleted }, counter_cache: true
  has_many :business_hours, dependent: :delete_all
  has_many :reviews, dependent: :delete_all
  has_many :notifications_generated,
           as: :target, class_name: 'Notification', dependent: :delete_all
  accepts_nested_attributes_for :social_links,
                                allow_destroy: true,
                                reject_if: :reject_link_attrs
  accepts_nested_attributes_for :review_links,
                                allow_destroy: true,
                                reject_if: :reject_link_attrs
  accepts_nested_attributes_for :business_hours, allow_destroy: true, reject_if: ->(attributes) { attributes['days'].blank? || attributes['status'].blank? }

  default_scope { order(name: :asc) }
  scope :brightlocal, -> { where("bright_local_report_id != NULL OR bright_local_report_id != '' OR reviews_count > 0") }

  geocoded_by :loc_address, latitude: :lat, longitude: :lng
  after_validation :geocode,
                   if: -> { (changes.keys & %w[address city state country zip]).present? }

  attr_accessor :files, :current_user

  before_create :attributes_changed?
  after_save do
    if current_user.present?
      if !current_user.preview_user? && attributes_changed?
        admins = User.admins_mailing_list
        Notifier.location_info_updated(self, admins.pluck(:email), current_user).deliver_now
        User.admins_mailing_list.each do |recipient|
          recipient.notifications.create(
            actor: user, target: self,
            action: 'location.updated'
          )
        end
      end
    end
  end

  after_save :fetch_reviews!, if: :fetch_reviews?

  after_save :create_review_short_url,
             if: proc { saved_change_to_name? || saved_change_to_short_url.blank? }

  def slug_candidates
    if new_record?
      [
        :name,
        [:name, rand(1000..(Location.where(name: name).count * 1000)).to_s]
      ]
    else
      [
        :name,
        %i[name id]
      ]
    end
  end

  def should_generate_new_friendly_id?
    new_record? || slug.blank? || saved_change_to_name?
  end

  def reject_link_attrs(attributes)
    attributes['link_type'].blank? || attributes['link'].blank?
  end

  def as_json(options = {})
    if options[:all]
      super
    elsif options[:for_local_profile]
      data = super(options.merge(only: %i[id name local_profile_list address city state country zip phone lat lng website yext_store_id bright_local_campaign_id]))
    elsif options[:map_info]
      data = super(options.merge(only: %i[name address lat lng website]))
    elsif options[:for_yext_store]
      data = super(options.merge(only: %i[id name yext_store_id]))
    else
      data = super(options.merge(except: [:created_at]))
      data = data.merge(top_reviews_url: top_reviews_url)
      data = data.merge(review_url: review_url)
      data = data.merge(social_links: social_link_data, local_profile_enabled: local_profile_enabled, updated_at: updated_at_ago, working_hours: business_hours_data, review_links: review_links_data) unless new_record?
    end
    data
  end

  def create_review_short_url
    update_column(:short_url, review_url)
  end

  def review_url
    "https://#{ENV['REVIEWS_URL']}/#{business.slug}/#{slug}"
  end

  def set_protocol(protocol, url)
    uri = URI.parse(url)
    uri.scheme = protocol
    uri.to_s
  end

  def top_reviews_url
    Rails.application.routes.url_helpers.location_reviews_url(obfuscated_id, host: ROOT_URL)
  end

  def local_profile_enabled
    business.local_profile_service
  end

  def social_link_data
    social_links.as_json
  end

  def review_links_data
    review_links.as_json
  end

  def business_hours_data
    business_hours.order(:id).as_json
  end

  def updated_at_ago
    (Date.current - updated_at.to_date).to_i
  end

  def address_fields
    attributes.slice('name', 'address', 'phone', 'city', 'state', 'zip')
              .symbolize_keys
  end

  def to_csv
    attribute_name = %w[
      Name Address City State Country Zip PhoneNumber MobileNumber Toll Website
      EnquiryMail Fax Categories OperationalHours PaymentMethods
      ProductsServices Brands Languages ProfessionalAssociation
      ShortDescription MediumDescription FullDescription LongDescription
      NumberOfUsers EstablishedYear CampaignName
    ]
    attributes = %w[
      name address city state country zip phone mobile_phone toll_free website
      enquiry_email fax categories operational_hours payment_methods
      products_services brands languages professional_associations
      short_description medium_description full_description long_description
      number_of_users year_established
    ]
    CSV.generate(headers: true) do |csv_data|
      csv_data << attribute_name
      csv_row = self.attributes.values_at(*attributes)
      csv_row << business.name
      csv_data << csv_row
    end
  end

  def loc_address
    [address, city, state, country, zip].compact.join(', ')
  end

  def fetch_reviews!
    ReviewsJob.perform_later(self)
  end

  def fetch_reviews?
    (saved_change_to_bright_local_report_id? && bright_local_report_id.present?) ||
      (saved_change_to_yext_store_id? && yext_store_id.present?)
  end

  def fetch_latest_reviews
    if update_yext_reviews?
      get_yext_reviews
    elsif update_brightlocal_reviews?
      get_brightlocal_reviews
    end
  end

  def update_brightlocal_reviews?
    bright_local_report_id.present? && yext_store_id.blank?
  end

  def update_yext_reviews?
    yext_store_id.present?
  end

  def yelp_link
    review_links.where(link_type: 'Yelp').first&.link
  end

  def google_link
    review_links.where(link_type: 'Google').first&.link
  end

  private

  def attributes_changed?
    changes_to_save.except(
      'id', 'user_id', 'created_at', 'updated_at', 'business_id',
      'local_profile_list', 'slug', 'local_profile_last_upload', 'short_url',
      'lat', 'lng', 'yext_store_id', 'yext_listings', 'bright_local_report_id',
      'bl_reviews_info', 'yext_reviews_info', 'average_rating',
      'positive_review_coupon', 'negative_review_coupon'
    ).delete_if { |_k, v| v[1].is_a?(Array) ? v[1].flatten.compact.blank? : v[1].blank? }.count > 0
  end

  def get_total_reviews_count(data, reviews_data, service)
    attr = case service
           when 'brightlocal'
             rid = bright_local_report_id
             :bl_reviews_info
           when 'yext'
             rid = yext_store_id
             :yext_reviews_info
           end
    if data['success']
      reviews_data['prev_count'] = reviews_data['count'].to_i
      reviews_data['count'] = data['count'].to_i

      reviews_data['count_prev_updated_at'] = reviews_data['count_updated_at']
      reviews_data['count_updated_at'] = Time.current

      reviews_data['latest_count'] =
        reviews_data['count'] - reviews_data['prev_count']
      reviews_data['latest_count'] =
        reviews_data['latest_count'] >= 0 ? reviews_data['latest_count'] : 0

      if !reviews_data['count_prev_updated_at'] ||
         (reviews_data['latest_count'].positive? ||
           ((reviews_data['count_prev_updated_at'].to_date -
             reviews_data['count_updated_at'].to_date) > 7.days))
        update_attribute(attr, reviews_data)
      else
        false
      end
    else
      ErrorNotify.reviews_error(data['errors'], rid).deliver_now
      false
    end
  end

  def get_brightlocal_reviews
    data = get_reviews_count_bl(bright_local_report_id)
    reviews_data = bl_reviews_info
    return unless get_total_reviews_count(data, reviews_data, 'brightlocal')

    total = !!bl_reviews_info['count_prev_updated_at'] ? bl_reviews_info['latest_count'] : bl_reviews_info['count']
    bl_reviews = []

    (total / 100.0).ceil.times do |i|
      data = get_reviews_bl bright_local_report_id, i * 100
      if data['success']
        bl_reviews += (data['reviews'])
      else
        ErrorNotify.reviews_error(data['errors'], bright_local_report_id).deliver_now
      end
    end

    bl_reviews_collection = []
    bl_reviews.map do |r|
      # next if r['directory'].casecmp('YELP').zero?
      r['unique_hash'] = r.delete('hash')

      bl_reviews_collection << r
    end
    reviews.create(bl_reviews_collection)
  end

  def get_yext_reviews
    data = YextApi.new(business.yext_creds).reviews_count(yext_store_id)
    reviews_data = yext_reviews_info
    return unless get_total_reviews_count(data, reviews_data, 'yext')

    total = !!yext_reviews_info['count_prev_updated_at'] ? yext_reviews_info['latest_count'] : yext_reviews_info['count']
    yext_reviews = []

    (total / 100.0).ceil.times do |i|
      data = YextApi.new(business.yext_creds)
                    .fetch_reviews(yext_store_id, i * 100)
      if data['success']
        yext_reviews += (data['reviews'])
      else
        ErrorNotify.reviews_error(data['errors'], yext_store_id).deliver_now
      end
    end

    yext_reviews_collection = []
    yext_reviews.each do |r|
      siteId = r.delete('publisherId')
      # next if siteId.casecmp('YELP').zero?

      r['unique_hash'] = r.delete('id')
      r['text'] = r.delete('content')
      r['author'] = r.delete('authorName')
      r['rating'] = r.delete('rating').to_i
      r['timestamp'] = r.delete('publisherDate')
      r['name'] = begin
                    REVIEW_DIRS[siteId]['name']
                  rescue StandardError
                    siteId.downcase
                  end
      r['directory'] = begin
                         REVIEW_DIRS[siteId]['directory']
                       rescue StandardError
                         siteId.downcase
                       end

      r.delete('comments')
      r.delete('locationId')
      r.delete('accountId')
      r.delete('lastYextUpdateTime')
      r.delete('flagStatus')
      r.delete('reviewType')
      r.delete('reviewLanguage')

      yext_reviews_collection << r
    end
    reviews.create(yext_reviews_collection)
  end
end
