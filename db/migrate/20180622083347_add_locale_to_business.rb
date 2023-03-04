class AddLocaleToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :locale, :string, default: 'en-us'
  end
end
