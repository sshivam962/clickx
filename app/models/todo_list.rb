class TodoList < ApplicationRecord
  belongs_to :agency

  has_many :todo_items, -> { order(position: :asc) }, dependent: :delete_all

  validates :title, presence: true

  def stats
    todo_items_count = todo_items.count
    todo_items_complete = todo_items.completed.count

    "#{todo_items_complete}/#{todo_items_count}"
  end
end
