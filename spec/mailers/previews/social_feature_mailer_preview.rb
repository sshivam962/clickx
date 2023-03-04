# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/social_feature_mailer
class SocialFeatureMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/social_feature_mailer/failed_to_post
  def failed_to_post
    SocialFeatureMailer.failed_to_post
  end
end
