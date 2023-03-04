class FacebookAd < ApplicationRecord
  obfuscatable

  CATEGORY_TYPES = {
    'facebook_ads' => 'FacebookAds',
    'plug_and_play_ads' => 'PlugAndPlayAds',
    'social_media_ads' => 'SocialMediaAds'
  }
  enum category_type: CATEGORY_TYPES

  has_many :images, class_name: 'FacebookAdImage', dependent: :destroy,
            inverse_of: :facebook_ad

  has_one :image, as: :imageable, inverse_of: :imageable
  has_one :thumbnail, as: :thumbnailable, inverse_of: :thumbnailable

  accepts_nested_attributes_for :images,
    reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :thumbnail,
    reject_if: :all_blank, allow_destroy: true
end
