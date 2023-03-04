class AddColumnsToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :show_on_recording, :boolean, default: false
  end
end