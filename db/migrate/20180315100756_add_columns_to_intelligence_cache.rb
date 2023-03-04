class AddColumnsToIntelligenceCache < ActiveRecord::Migration[5.1]
  def change
    add_column :intelligence_caches, :google_analytics, :jsonb
    add_column :intelligence_caches, :google_search_console, :jsonb
    add_column :intelligence_caches, :adwords, :jsonb
    add_column :intelligence_caches, :retargeting_summary, :jsonb
    add_column :intelligence_caches, :competitions, :jsonb
    add_column :intelligence_caches, :backlinks, :jsonb
    add_column :intelligence_caches, :reviews_stars, :jsonb
    add_column :intelligence_caches, :datewise_rankings, :jsonb
    add_column :intelligence_caches, :call_analytics, :jsonb
  end
end
