class AddLastUpdatedForKdiAndVolumeToSemrushKeywords < ActiveRecord::Migration[5.1]
  def change
    add_column :semrush_keywords, :kdi_last_updated_at, :date
    add_column :semrush_keywords, :search_volume_last_updated_at, :date
  end
end
