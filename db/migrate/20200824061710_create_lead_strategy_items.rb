class CreateLeadStrategyItems < ActiveRecord::Migration[5.1]
  def change
    create_table :lead_strategy_items do |t|
      t.integer :category
      t.text :strategy

      t.timestamps
    end
  end
end
