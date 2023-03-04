class AddReviewInfoFieldToLocation < ActiveRecord::Migration[4.2]
  def up
    add_column :locations, :reviews_info, :json, default: {}, null: false
    remove_column :locations, :brightlocal_reviews
  end

  def down
    add_column :locations, :brightlocal_reviews, :json, default: {}, null: false
    remove_column :locations, :reviews_info
  end
end
