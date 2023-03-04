class CreateIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :industries do |t|
      t.string :title, null: false
      t.string :logo
      t.string :icon_klass

      t.timestamps
    end
  end
end
