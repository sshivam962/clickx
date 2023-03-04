class CreateCaseStudies < ActiveRecord::Migration[5.1]
  def change
    create_table :case_studies do |t|
      t.string :title, null: false
      t.string :logo
      t.string :descriptive_image
      t.text :description

      t.references :industry, index: true
      t.timestamps
    end
  end
end
