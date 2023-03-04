class RemoveApiRequests < ActiveRecord::Migration[5.2]
  def up
    drop_table :api_requests
  end

  def down
    create_table :api_requests do |t|
      t.text :url

      t.timestamps null: false
    end

    add_index :api_requests, :url, unique: true
  end
end
