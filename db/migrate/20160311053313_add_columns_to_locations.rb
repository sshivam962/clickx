class AddColumnsToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :positive_review_coupon, :string
    add_column :locations, :negative_review_coupon, :string
  end
end
