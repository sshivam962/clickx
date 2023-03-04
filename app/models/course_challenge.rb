class CourseChallenge < ApplicationRecord
  validates :position, presence: true, uniqueness: true
  validates :name, presence: true
  
end
