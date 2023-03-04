class RemoveImplementationFeesFromAgencies < ActiveRecord::Migration[5.1]
  def change
    remove_column :agencies, :implementation_fees
  end
end
