class ReAddUniqIndexToMaterialisedView < ActiveRecord::Migration[4.2]
  def change
    add_index :keyword_monthly_rankings_view,[:date, :business_id, :keyword_id], 
      unique: true,
      name: :keyword_monthly_rankings_view_uniq_index
  end
end
