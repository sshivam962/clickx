class AddCategoryToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :free, :boolean, default: false
  end
end
