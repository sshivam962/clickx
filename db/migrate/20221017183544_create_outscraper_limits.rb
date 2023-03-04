class CreateOutscraperLimits < ActiveRecord::Migration[5.2]
  def change
    create_table :outscraper_limits do |t|
      t.integer :credit_balance, default: 0
      t.integer :download_limit, default: 5
      t.integer :max_requests, default: 5
      t.integer :total_downloads, default: 0
      t.references :agency, foreign_key: true

      t.timestamps
    end
  end
end
