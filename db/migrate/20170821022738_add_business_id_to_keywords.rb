class AddBusinessIdToKeywords < ActiveRecord::Migration[4.2]
  def change
    add_column :keywords, :business_id, :integer, index: true
  end
end
