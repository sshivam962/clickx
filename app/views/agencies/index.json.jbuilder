# frozen_string_literal: true

json.agency do
  json.array!(@agencies) do |agency|
    json.merge! agency.attributes
    json.login_user_id agency.preview_users&.first&.id
    json.users agency.users
    json.businesses_count agency.businesses.count
    json.last_month_customers agency.businesses.where('created_at BETWEEN ? AND ?', 1.month.ago.beginning_of_month, 1.month.ago.end_of_month).count
  end
end
