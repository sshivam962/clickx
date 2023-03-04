class CreateFavoriteCaseStudies < ActiveRecord::Migration[5.1]
  def change
    create_table :favorite_case_studies do |t|
      t.references :case_study, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
