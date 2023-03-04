class CreateOutscrapperRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :outscrapper_requests do |t|
      t.references :agency, foreign_key: true
      t.string :external_requests_id, null: false
      t.string :outscrapper_status
      t.text :request_query

      t.timestamps
    end
  end
end
