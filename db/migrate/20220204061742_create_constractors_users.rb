class CreateConstractorsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :constractors_users do |t|
      t.string :email, unique: true
      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.string :phone
      t.integer :created_by
      t.datetime :deleted_at

   
      t.timestamps
    end
    add_index :constractors_users, :email, unique: true
    add_index :constractors_users, :created_by
    add_index :constractors_users, :deleted_at
  end
end
