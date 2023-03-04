class AddRetryCountToOutscrapperRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_requests, :retry_count, :integer, default: 0
  end
end
