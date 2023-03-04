class RemoveBlColumnsFromBusiness < ActiveRecord::Migration[4.2]
  def up
    remove_column :businesses, :bright_local_report_id
    remove_column :businesses, :brightlocal_reviews
  end

  def down
    add_column :businesses, :bright_local_report_id, :string
    add_column :businesses, :brightlocal_reviews, :json, null: false, default: {}
  end
end
