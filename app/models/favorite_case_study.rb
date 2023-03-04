class FavoriteCaseStudy < ApplicationRecord
  belongs_to :user
  belongs_to :case_study
end
