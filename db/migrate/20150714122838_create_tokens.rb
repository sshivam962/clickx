class CreateTokens < ActiveRecord::Migration[4.2]
  def change
    create_table :tokens do |t|
      t.string   :code_type
      t.string   :access_token
      t.string   :refresh_token
      t.integer  :expires_in 
      t.datetime :expires_at
      t.datetime :issued_at

      t.timestamps null: false
    end
  end
end
