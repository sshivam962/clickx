class CreateWebDevelopment < ActiveRecord::Migration[5.2]
  def change
    create_table :web_developments do |t|
      t.integer :web_development_id
      t.string :project_name
      t.string :project_url
      t.string :project_detail
      t.references :agency, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
