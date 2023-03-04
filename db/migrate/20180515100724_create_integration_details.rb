class CreateIntegrationDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :integration_details do |t|
      t.jsonb :details, default: {}
      t.belongs_to :business, index: true
      t.timestamps
    end
  end
end
