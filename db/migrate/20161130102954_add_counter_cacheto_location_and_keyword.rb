class AddCounterCachetoLocationAndKeyword < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses ,:locations_count,:integer,default: 0
    add_column :businesses ,:keywords_count,:integer,default: 0
    reversible do |dir|
      dir.up {data}
    end
  end

  def data
    execute <<-SQL.squish
      UPDATE businesses
        SET locations_count = (
          SELECT count(1)
            FROM locations
            WHERE locations.business_id = businesses.id
        )
    SQL
    execute <<-SQL.squish
      UPDATE businesses
      SET keywords_count = (
          SELECT count(1)
            FROM business_keywords
            WHERE business_keywords.business_id = businesses.id
 
        )
    SQL
  end
end
