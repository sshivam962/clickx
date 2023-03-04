class RenameReviewsInfoColumn < ActiveRecord::Migration[4.2]
  def up
    rename_column :locations, :reviews_info, :bl_reviews_info
  end

  def down
    rename_column :locations, :bl_reviews_info, :reviews_info
  end
end
