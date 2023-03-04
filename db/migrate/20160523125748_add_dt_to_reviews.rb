class AddDtToReviews < ActiveRecord::Migration[4.2]
  def change
    add_column :reviews, :dt, :datetime
  end
end
