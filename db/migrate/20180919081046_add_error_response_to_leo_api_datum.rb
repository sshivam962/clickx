class AddErrorResponseToLeoApiDatum < ActiveRecord::Migration[5.1]
  def up
    add_column :leo_api_data, :error_response, :string
  end

  def down
    remove_column :leo_api_data, :error_response, :string
  end
end
