# frozen_string_literal: true

class Question < ApplicationRecord
  has_paper_trail only: %i[question description]
  validates :question, :exp_ans_type, presence: true
  validates :is_published, default: false
  validates :is_mandatory, default: false
  validates :exp_ans_type, inclusion: {
    in: %w[oneliner paragraph boolean_ans mcq],
    message: 'not a valid expected answer'
  }

  default_scope { order(group_id: :asc, order: :asc) }
  belongs_to :group
  acts_as_list scope: :group

  def as_json(options = {})
    data = super
    data = data.merge(version_no: versions.last&.index.to_i + 1)
    data
  end
end
