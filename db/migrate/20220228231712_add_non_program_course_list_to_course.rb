class AddNonProgramCourseListToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :non_program_course_list, :boolean, default: false
  end
end
