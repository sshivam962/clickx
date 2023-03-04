class AddAgencyIdsToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :permitted_agencies_ids, :text, array: true, default: []
  end
end
