class ChangeArrayColumnDefaultType < ActiveRecord::Migration[4.2]
  def change
    change_column :businesses, :wufoo_ids, :string, array: true, default: []
    change_column :businesses, :unbounce_ids, :string, array: true, default: []
  end
end
