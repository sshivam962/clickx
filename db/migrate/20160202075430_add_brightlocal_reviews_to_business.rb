class AddBrightlocalReviewsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :brightlocal_reviews, :json, default: {}, null: false
  end
end
