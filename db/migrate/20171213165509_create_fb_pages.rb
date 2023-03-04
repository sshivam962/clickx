class CreateFbPages < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_pages do |t|
      t.integer :page_id
      t.string :access_token
      t.integer :business_id

      t.timestamps
    end
  end
end
