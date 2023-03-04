class AddAllowClientDuplicationToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :allow_client_duplication, :boolean, default: false
  end
end
