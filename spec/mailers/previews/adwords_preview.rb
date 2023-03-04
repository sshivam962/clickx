# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/adwords
class AdwordsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/adwords/disconnect_account
  def disconnect_account
    AdwordsMailer.disconnect_account
  end
end
