class CreateClickxPackages < ActiveRecord::Migration[5.1]
  def change
    create_table :clickx_packages do |t|
      t.string :name
      t.string :key
      t.text :sales_pitch
      t.boolean :sales_pitch_enabled, default: false

      t.timestamps
    end
  end
end
