class MailgunSubdomain < ApplicationRecord
  has_encrypted :user_name, :password

  validates :subdomain, uniqueness: true, presence: true
  validates :user_name, presence: true
  validates :password, presence: true
end
