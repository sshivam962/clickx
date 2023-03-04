class AddReadabilityToLeoApiData < ActiveRecord::Migration[4.2]
  def change
    add_column :leo_api_data, :readability, :json
  end
end
