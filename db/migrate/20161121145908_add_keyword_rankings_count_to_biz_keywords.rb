class AddKeywordRankingsCountToBizKeywords < ActiveRecord::Migration[4.2]
  def up
    add_column :business_keywords, :keyword_rankings_count, :integer
    # BusinessKeyword.with_deleted.find_each { |biz_keyword| BusinessKeyword.reset_counters(biz_keyword.id, :keyword_rankings)}
  end

  def down
    remove_column :business_keywords, :keyword_rankings
  end
end
