class CreateLeadSourceEmailTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :lead_source_email_templates do |t|
      t.references :email_template, foreign_key: true
      t.references :lead_source, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
