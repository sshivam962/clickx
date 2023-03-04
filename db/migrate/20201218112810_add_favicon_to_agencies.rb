class AddFaviconToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :favicon, :string
  end
end
