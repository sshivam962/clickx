class AddZipToOutscrapperRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_requests, :zip_codes, :string, default: ''
  end
end
