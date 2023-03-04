class CreateTrackerContactFormIntegrations < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_contact_form_integrations do |t|
      t.jsonb :config, default: {}
      t.string :integration
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
