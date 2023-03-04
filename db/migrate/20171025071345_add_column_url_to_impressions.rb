class AddColumnUrlToImpressions < ActiveRecord::Migration[4.2]
  def change
    add_column :impressions, :url, :string
  end
end
