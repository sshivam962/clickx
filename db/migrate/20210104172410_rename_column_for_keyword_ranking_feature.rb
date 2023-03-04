class RenameColumnForKeywordRankingFeature < ActiveRecord::Migration[5.1]
  def up
    rename_column :businesses, :keyword_ranking_disabled, :keyword_ranking_service
    change_column_default :businesses, :keyword_ranking_service, true

    Business.update_all(keyword_ranking_service: true)
  end

  def down
    rename_column :businesses, :keyword_ranking_service, :keyword_ranking_disabled
    change_column_default :businesses, :keyword_ranking_disabled, false

    Business.update_all(keyword_ranking_service: false)
  end
end
