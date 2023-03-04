class CreateFbLeadGenFormSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_lead_gen_form_submissions do |t|
      t.string :submission_id
      t.jsonb :field_data
      t.references :business, foreign_key: true

      t.timestamps
    end
  end
end
