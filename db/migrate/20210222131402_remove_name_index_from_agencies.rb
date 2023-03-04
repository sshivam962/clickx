class RemoveNameIndexFromAgencies < ActiveRecord::Migration[5.1]
  def up
    remove_index :agencies, name: 'index_agencies_on_name'
  end

  def down
    add_index :agencies, :name, name: 'index_agencies_on_name'
  end
end
