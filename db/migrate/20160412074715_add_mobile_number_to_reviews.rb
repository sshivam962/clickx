class AddMobileNumberToReviews < ActiveRecord::Migration[4.2]
  def change
    add_column :reviews, :phone_number, :string
  end
end
