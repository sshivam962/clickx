class AddBusinessIdToTokens < ActiveRecord::Migration[4.2]
  def change
    add_column :tokens, :business_id, :integer
  end
end
