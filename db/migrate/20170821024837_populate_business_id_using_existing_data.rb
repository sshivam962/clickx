class PopulateBusinessIdUsingExistingData < ActiveRecord::Migration[4.2]
  def up
    Keyword.connection.execute(<<~SQL
      UPDATE keywords
      SET business_id = business_keywords.business_id
      FROM business_keywords
      WHERE keywords.id = business_keywords.keyword_id
      SQL
    )
  end
end
