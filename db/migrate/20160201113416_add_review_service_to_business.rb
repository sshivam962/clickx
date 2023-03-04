class AddReviewServiceToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :review_service, :boolean, default: false
    add_column :businesses, :bright_local_report_id, :string
  end
end
