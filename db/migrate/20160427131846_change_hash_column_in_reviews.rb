class ChangeHashColumnInReviews < ActiveRecord::Migration[4.2]
  def change
    add_column :reviews, :unique_hash, :text
  end
end
