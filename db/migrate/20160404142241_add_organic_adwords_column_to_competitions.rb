class AddOrganicAdwordsColumnToCompetitions < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :keywords_organic, :json, default: {}, null: false
    add_column :competitions, :keywords_adwords, :json, default: {}, null: false
  end
end
