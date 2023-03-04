class CreateLogins < ActiveRecord::Migration[4.2]
  def change
    create_table :logins do |t|
      t.string :title
      t.string :username
      t.string :password
      t.string :notes

      t.timestamps null: false
    end
  end
end
