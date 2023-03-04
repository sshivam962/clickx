class CreateStrategyImages < ActiveRecord::Migration[5.1]
  def change
    create_table :strategy_images do |t|
      t.belongs_to :lead_strategy, null: false, type: :uuid, foreign_key: true, index: true
      t.string :file

      t.timestamps
    end
  end
end
