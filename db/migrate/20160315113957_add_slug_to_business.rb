class AddSlugToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :slug, :string
  end
end
