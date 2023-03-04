class AddSearchConsoleServiceToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :site_url, :string, null: false, default: ""
    add_column :businesses, :search_console_service, :boolean, default: false
  end
end
