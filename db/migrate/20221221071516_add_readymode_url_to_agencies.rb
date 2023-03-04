class AddReadymodeUrlToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :readymode_url, :string
  end
end
