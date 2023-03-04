class AddCallrailIdToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :callrail_id, :string, default: nil
    add_column :businesses, :callrail_account_id, :string, default: nil
    add_column :businesses, :callrail_company_id, :string, default: nil
  end
end
