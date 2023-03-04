class CreateWriterForms < ActiveRecord::Migration[4.2]
  def change
    create_table :writer_forms do |t|
      t.json :product_type, :default => {}
      t.json :industry, :default => {}
      t.json :specialty, :default => {}
      t.json :field_layout, :default => {}

      t.timestamps null: false
    end
  end
end
