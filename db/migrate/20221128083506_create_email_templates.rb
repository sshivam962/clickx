class CreateEmailTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :email_templates do |t|
      t.string :name
      t.text :content
      t.string :subject
      t.text :wordpress_site_custom_content
      t.references :agency, foreign_key: true

      t.timestamps
    end
  end
end
