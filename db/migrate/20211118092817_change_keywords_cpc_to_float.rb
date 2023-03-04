class ChangeKeywordsCpcToFloat < ActiveRecord::Migration[5.1]
  def up
    SemrushKeyword.where(cpc: 'n/a').update_all(cpc: nil)
    change_column :semrush_keywords, :cpc, 'float USING CAST(cpc AS float)'
  end

  def down
    change_column :semrush_keywords, :cpc, :string
  end
end
