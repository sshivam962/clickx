class CreateContents < ActiveRecord::Migration[4.2]
  def change
    create_table :contents do |t|
      t.string  :title
      t.string  :link
      t.string  :state
      t.text    :content
      t.integer :business_id, null: false

      t.timestamps null: false
    end
  end
end
