class CreateUsersCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :users_courses do |t|
      t.references :user
      t.references :course

      t.timestamps
    end
  end

  def down
    drop_table :users_courses
  end
end
