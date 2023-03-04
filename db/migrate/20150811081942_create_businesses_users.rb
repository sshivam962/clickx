class CreateBusinessesUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :businesses_users  do |t|
      t.references :business
      t.references :user
      t.timestamps null: false
    end
    add_index :businesses_users, [:business_id, :user_id]
  end
end
