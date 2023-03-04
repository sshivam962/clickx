class AddBlFieldsToLocation < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :bright_local_report_id, :string
    add_column :locations, :brightlocal_reviews, :json, default: {}, null: false
  end
end
