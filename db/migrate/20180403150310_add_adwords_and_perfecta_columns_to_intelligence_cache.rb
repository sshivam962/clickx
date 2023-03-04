class AddAdwordsAndPerfectaColumnsToIntelligenceCache < ActiveRecord::Migration[5.1]
  def change
    add_column :intelligence_caches, :last_30_days_adwords_display_summary, :jsonb
    add_column :intelligence_caches, :last_30_days_perfecta_reports, :jsonb
  end
end
