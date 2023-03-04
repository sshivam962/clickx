class CaseStudyImage < ApplicationRecord
  belongs_to :case_study

  mount_uploader :file, ImageUploader

  acts_as_list scope: :case_study
end
