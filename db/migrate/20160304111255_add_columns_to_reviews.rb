class AddColumnsToReviews < ActiveRecord::Migration[4.2]
  def change
    add_column :reviews, :rating, :float
    add_column :reviews, :content, :text
    add_column :reviews, :email, :string
    add_column :reviews, :location_id, :integer
  end
end
