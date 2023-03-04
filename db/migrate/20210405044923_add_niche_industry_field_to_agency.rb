class AddNicheIndustryFieldToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :niche_industry, :text
  end
end
