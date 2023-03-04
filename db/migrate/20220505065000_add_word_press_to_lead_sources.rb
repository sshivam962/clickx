class AddWordPressToLeadSources < ActiveRecord::Migration[5.2]
  def change
    add_column :lead_sources, :word_press, :text
  end
end
