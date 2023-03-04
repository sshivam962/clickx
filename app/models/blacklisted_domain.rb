class BlacklistedDomain < ApplicationRecord
  validates :name, presence: true
end
