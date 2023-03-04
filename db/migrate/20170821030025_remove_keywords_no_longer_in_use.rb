class RemoveKeywordsNoLongerInUse < ActiveRecord::Migration[4.2]
  def change
    Keyword.connection.execute(<<~SQL
      DELETE from  keywords
      WHERE business_id is NULL
      SQL
    )
  end
end
