class CreateAgenciesCourses < ActiveRecord::Migration[5.1]
  def up
    create_table :agencies_courses do |t|
      t.references :agency
      t.references :course

      t.timestamps
    end

    Course.agency.find_each do |course|
      course.agency_ids = course.permitted_resources_ids
    end
  end

  def down
    drop_table :agencies_courses
  end
end
