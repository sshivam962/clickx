class AddStateToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :state, :string
  end
end
