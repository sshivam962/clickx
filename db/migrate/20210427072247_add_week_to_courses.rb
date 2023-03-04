class AddWeekToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :week, :integer
  end
end
