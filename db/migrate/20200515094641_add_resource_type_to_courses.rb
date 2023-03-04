class AddResourceTypeToCourses < ActiveRecord::Migration[5.1]
  def up
    add_column :courses, :resource_type, :integer
    Course.update_all(resource_type: 'agency')
  end

  def down
    remove_column :courses, :resource_type
  end
end
