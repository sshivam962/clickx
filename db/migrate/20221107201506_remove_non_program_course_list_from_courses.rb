class RemoveNonProgramCourseListFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :courses, :non_program_course_list, :boolean, default: false
  end
end
