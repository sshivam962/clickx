class AddLimitFieldsToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :clients_limit, :integer, default: 10
    add_column :agencies, :keywords_limit, :integer, default: 1000
    add_column :agencies, :competitors_limit, :integer, default: 100
  end
end
