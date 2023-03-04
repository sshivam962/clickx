class ActionStep < ApplicationRecord
  belongs_to :chapter
  acts_as_list scope: :chapter
  has_many :completed_action_steps,  dependent: :destroy
end
