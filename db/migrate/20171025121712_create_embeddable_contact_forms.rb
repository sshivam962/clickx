class CreateEmbeddableContactForms < ActiveRecord::Migration[5.1]
  def change
    create_table :embeddable_contact_forms do |t|
      t.string :name
      t.boolean :populate_with_default_values, default: false
      t.boolean :enable_captcha, default: false
      t.string :notify_submissions, array: true
      t.integer :submissions_count, default: 0
      t.integer :impressions_count, default: 0

      t.timestamps
    end
  end
end
