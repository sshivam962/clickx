class FixMissingDataFromKeywordMigration < ActiveRecord::Migration[4.2]
  def up
    result = ActiveRecord::Base.connection.execute("SELECT DISTINCT ON(business_keywords.id)
                               keywords.id as keyword_id,
                               businesses.id AS business_id,
                               business_keywords.id AS bk_id,
                               keywords.name AS key_name,
                               keywords.city AS key_city
                               FROM businesses
                               INNER JOIN business_keywords ON business_keywords.business_id = businesses.id
                               INNER JOIN keywords ON keywords.id = business_keywords.keyword_id")
    result.each do |tuple|
      next if Keyword.exists?(
        id: tuple['keyword_id'],
        business_id: tuple['business_id']
      )

      keyword = Keyword.create(
        business_id: tuple['business_id'],
        name: tuple['key_name'],
        city: tuple['key_city']
      )

      KeywordRanking.where(business_keyword_id: tuple['bk_id']).update_all(keyword_id: keyword.id)
    end
  end
end
