class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.references :agency, foreign_key: true
      t.string :title
      t.string :type_of_employment
      t.text :description
      t.float :budget
      t.string :primary_skill
      t.string :specific_primary_skill
      t.string :other_skill
      t.string :specific_other_skill
      t.string :other_skill_2
      t.string :specific_other_skill_2

      t.timestamps
    end
  end
end
