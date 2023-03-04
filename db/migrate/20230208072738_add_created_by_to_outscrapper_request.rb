class AddCreatedByToOutscrapperRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_requests, :created_by, :integer
    add_index :outscrapper_requests, :created_by
  end
end
