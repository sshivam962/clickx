class RemoveCloseioFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    drop_table :closeio_auths do |t|
      t.string :api_key, null: false
      t.integer :business_id, null: false

      t.timestamps null: false
    end
    remove_column :businesses, :closeio_service, :boolean, default: false
  end
end
