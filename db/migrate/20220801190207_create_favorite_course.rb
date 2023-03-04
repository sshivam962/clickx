class CreateFavoriteCourse < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_courses do |t|
      t.references :course
      t.references :user
      t.timestamps
    end
  end
end
