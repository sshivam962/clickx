class CreateDomainRankings < ActiveRecord::Migration[5.1]
  def self.up
    create_table :domain_rankings do |t|
      t.integer :keyword_name
      t.date :rank_date
      t.jsonb :domain_rank

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :domain_rankings
  end
end
