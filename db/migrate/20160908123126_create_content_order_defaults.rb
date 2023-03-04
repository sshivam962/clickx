class CreateContentOrderDefaults < ActiveRecord::Migration[4.2]
  def change
    create_table :content_order_defaults do |t|
      t.string :company_information
      t.string :target_audience
      t.string :things_to_mention
      t.string :things_to_avoid
      t.integer :business_id

      t.timestamps null: false
    end
  end
end
