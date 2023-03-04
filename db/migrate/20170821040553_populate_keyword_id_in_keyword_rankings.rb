class PopulateKeywordIdInKeywordRankings < ActiveRecord::Migration[4.2]
  def up
    Rails.logger.info "This is expensive query, can take upto 30 miuntes"

    Keyword.connection.execute(<<~SQL
      UPDATE keyword_rankings
       SET keyword_id= business_keywords.keyword_id
       FROM business_keywords
       WHERE keyword_rankings.business_keyword_id = business_keywords.id
    SQL
    )
  end
end
