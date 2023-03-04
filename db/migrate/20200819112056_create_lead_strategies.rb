class CreateLeadStrategies < ActiveRecord::Migration[5.1]
  def change
    create_table :lead_strategies, id: :uuid do |t|
      t.string :category
      t.integer :status
      t.references :lead
      t.text :strategies, array: true, default: []

      t.timestamps
    end
  end
end
