SOCIAL_LINK_OPTIONS = [
  'Youtube Channel',
  'Facebook',
  'Twitter',
  'Pinterest',
  'Google Plus Company Profile',
  'Google My Business',
  'Linkedin Business Page',
  'Instagram',
  'Houzz',
  'Yahoo',
  'Yelp'
].freeze

REVIEW_LINK_OPTIONS = %w[Google Yelp].freeze

DECODED_VAPID_PUBLIC_KEY =
  Base64.urlsafe_decode64(ENV['VAPID_PUBLIC_KEY'] || '').bytes.freeze
