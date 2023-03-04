class CreateLeadStrategyFunnels < ActiveRecord::Migration[5.1]
  def change
    create_table :lead_strategy_funnels do |t|
      t.string :funnel_type
      t.string :category
      t.string :content
      t.integer :position

      t.timestamps
    end
  end
end
