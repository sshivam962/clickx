class CreateOntraportAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :ontraport_auths do |t|
      t.string :app_id
      t.string :api_key
      t.integer :business_id

      t.timestamps
    end
  end
end
