class CreateMailTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :mail_templates do |t|
      t.text :paragraph1
      t.string :mail_type
      t.references :user

      t.timestamps null: false
    end
  end
end
