class CreateReviewLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :review_links do |t|
      t.string :link_type,    null: false
      t.string :link,         null: false

      t.references :location, index: true
      t.timestamps null: false
    end
  end
end
