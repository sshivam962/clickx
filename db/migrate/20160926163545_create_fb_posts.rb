class CreateFbPosts < ActiveRecord::Migration[4.2]
  def change
    create_table :fb_posts do |t|
      t.integer :user_id
      t.string :page_id
      t.string :post
      t.datetime :time
      t.integer :status

      t.timestamps null: false
    end
  end
end
