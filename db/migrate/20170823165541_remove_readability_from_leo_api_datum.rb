class RemoveReadabilityFromLeoApiDatum < ActiveRecord::Migration[4.2]
  def change
    remove_column :leo_api_data, :readability, :json
  end
end
