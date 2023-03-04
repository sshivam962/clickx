class TodoItem < ApplicationRecord
  belongs_to :todo_list
  acts_as_list scope: :todo_list

  scope :completed, -> { where(completed: true) }

  validates :content, presence: true, length: { minimum: 2 }

  def complete!
    update(completed: true)
  end

  def uncomplete!
    update(completed: false)
  end
end
