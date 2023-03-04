class AddAnchorTextDataToCompetitions < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :anchor_text_data, :json
  end
end
