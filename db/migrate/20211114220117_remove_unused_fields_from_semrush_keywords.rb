class RemoveUnusedFieldsFromSemrushKeywords < ActiveRecord::Migration[5.1]
  def change
    remove_column :semrush_keywords, :keyword_id
    remove_column :semrush_keywords, :last_week_google_change
    remove_column :semrush_keywords, :last_30_days_google_change
  end
end
