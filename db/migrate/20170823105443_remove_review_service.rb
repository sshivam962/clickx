class RemoveReviewService < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :review_service, :boolean, default: false
  end
end
