class CreateLeadSources < ActiveRecord::Migration[5.1]
  def change
    create_table :lead_sources do |t|
      t.string :name
      t.string :subject
      t.string :sequence_id
      t.string :closeio_user_id
      t.string :from_email
      t.boolean :enabled, default: true
      t.date :end_date
      t.text :email_template
      t.timestamps
    end
  end
end
