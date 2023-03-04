class ScaleProgramHeader < ApplicationRecord
  validates :week, presence: true, uniqueness: true
  validates :name, presence: true

  after_destroy do
    Course.where(week: week).update_all(week: nil)
  end

  after_update do
    if saved_change_to_week?
      Course.where(week: week_before_last_save).update_all(week: week)
    end
  end
end
