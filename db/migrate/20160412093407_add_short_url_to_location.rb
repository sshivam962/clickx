class AddShortUrlToLocation < ActiveRecord::Migration[4.2]
  def up
    add_column :locations, :short_url, :string
  end

  def down
    remove_column :locations, :short_url
  end
end
