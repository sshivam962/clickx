class AgenciesCourse < ApplicationRecord
  belongs_to :agency
  belongs_to :course
end
