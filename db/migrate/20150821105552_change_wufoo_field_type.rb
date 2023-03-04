class ChangeWufooFieldType < ActiveRecord::Migration[4.2]
  def change
    change_column :businesses, :wufoo_ids, :string, :array => true
  end
end
