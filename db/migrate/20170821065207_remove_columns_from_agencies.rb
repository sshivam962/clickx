class RemoveColumnsFromAgencies < ActiveRecord::Migration[4.2]
  def change
    remove_column :agencies, :deepcrawl_token, :string
    remove_column :agencies, :deepcrawl_token_updated_at, :datetime
  end
end
