class CreateMarketingPerformanceGoals < ActiveRecord::Migration[4.2]
  def change
    create_table :marketing_performance_goals do |t|
      t.integer :visits_per_month
      t.integer :contacts_per_month
      t.integer :customers_per_month
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
