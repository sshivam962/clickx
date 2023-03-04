class CreateCloseioAuth < ActiveRecord::Migration[5.1]
  def change
    create_table :closeio_auths do |t|
      t.string :api_key, null: false
      t.integer :business_id, null: false

      t.timestamps null: false
    end
  end
end
