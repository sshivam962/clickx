class CreateTrackerFormSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_form_submissions do |t|
      t.jsonb :data
      t.string :visitor_id
      t.string :visit_id

      t.references :business,  index: true
      t.timestamps null: false
    end
  end
end
