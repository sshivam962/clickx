class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :workable_jobs, id: :string do |t|
      t.string :full_title
      t.string :department
      t.string :url
      t.string :shortcode
      t.datetime :workable_created_at
      t.integer :category_id

      t.timestamps
    end
  end
end
