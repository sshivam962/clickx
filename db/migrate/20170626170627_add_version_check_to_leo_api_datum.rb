class AddVersionCheckToLeoApiDatum < ActiveRecord::Migration[4.2]
  def change
    add_column :leo_api_data, :version_check, :string
  end
end
