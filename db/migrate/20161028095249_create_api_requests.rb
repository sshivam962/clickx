class CreateApiRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :api_requests do |t|
      t.text :url

      t.timestamps null: false
    end

    add_index :api_requests, :url, unique: true
  end
end
