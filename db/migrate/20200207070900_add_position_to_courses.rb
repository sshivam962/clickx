class AddPositionToCourses < ActiveRecord::Migration[5.1]
  def up
    add_column :courses, :position, :integer

    Course.order(:updated_at).each.with_index(1) do |course, index|
      course.update_column :position, index
    end
  end

  def down
    remove_column :courses, :position
  end
end
