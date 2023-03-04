class CreateReviews < ActiveRecord::Migration[4.2]
  def change
    create_table :reviews do |t|

      t.timestamps null: false
    end
  end
end
