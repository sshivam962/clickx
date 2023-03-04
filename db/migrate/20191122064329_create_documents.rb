class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
