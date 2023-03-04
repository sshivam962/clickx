class AddColumnsToOutscrapperRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_requests, :categories, :string, array: true
    add_column :outscrapper_requests, :states, :string, array: true
    add_column :outscrapper_requests, :cities, :string, array: true
    add_column :outscrapper_requests, :limit, :integer, default: 0
  end
end
