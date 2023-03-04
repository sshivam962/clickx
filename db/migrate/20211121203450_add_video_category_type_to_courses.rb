class AddVideoCategoryTypeToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :video_category_type, :integer, default: 0
  end
end
