class EmailClickEvent < ApplicationRecord
  belongs_to :domain_contact, counter_cache: :email_clicks_count
end
