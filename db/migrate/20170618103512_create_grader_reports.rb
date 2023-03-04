class CreateGraderReports < ActiveRecord::Migration[4.2]
  def change
    create_table :grader_reports do |t|
      t.integer :business_id
      t.jsonb :desktop_insights, default: {}
      t.jsonb :mobile_insights, default: {}
      t.jsonb :landing_page, default: {}

      t.timestamps null: false
    end
  end
end
