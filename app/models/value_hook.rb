class ValueHook < ApplicationRecord
  obfuscatable
  has_one :thumbnail, as: :thumbnailable, inverse_of: :thumbnailable

  accepts_nested_attributes_for :thumbnail,
                              reject_if: :all_blank,
                              allow_destroy: true
end
