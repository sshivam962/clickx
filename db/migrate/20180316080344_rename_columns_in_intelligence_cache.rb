class RenameColumnsInIntelligenceCache < ActiveRecord::Migration[5.1]
  def change
    rename_column :intelligence_caches, :adwords, :last_30_days_adwords_ppc_summary
    rename_column :intelligence_caches, :google_analytics, :last_30_days_google_analytics
    rename_column :intelligence_caches, :google_search_console, :last_30_days_google_search_console
    rename_column :intelligence_caches, :retargeting_summary, :last_30_days_retargeting_summary
    rename_column :intelligence_caches, :competitions, :last_30_days_business_competitiors
    rename_column :intelligence_caches, :backlinks, :last_30_days_backlinks
    rename_column :intelligence_caches, :call_analytics, :last_30_days_call_analytics   
  end
end
