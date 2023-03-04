class AddYextReviewsInfoToLocation < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :yext_reviews_info, :json, default: {}
  end
end
