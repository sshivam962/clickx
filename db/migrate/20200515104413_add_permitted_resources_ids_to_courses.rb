class AddPermittedResourcesIdsToCourses < ActiveRecord::Migration[5.1]
  def up
    add_column :courses, :permitted_resources_ids, :text, array: true, default: []
    Course.find_each do | course |
      course.update(permitted_resources_ids: course.permitted_agencies_ids)
    end
  end

  def down
    remove_column :courses, :permitted_resources_ids
  end
end
