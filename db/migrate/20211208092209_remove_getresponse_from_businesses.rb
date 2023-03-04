class RemoveGetresponseFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :getresponse_integration, :jsonb
  end
end
