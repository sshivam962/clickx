class CreatePageForms < ActiveRecord::Migration[4.2]
  def change
    create_table :page_forms do |t|
      t.jsonb :forms
      t.string :uri
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
