class RemoveNameIndexFromLocation < ActiveRecord::Migration[4.2]
  def change
    remove_index(:locations, :name => 'index_locations_on_name')
  end
end
