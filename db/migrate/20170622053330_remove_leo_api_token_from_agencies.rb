class RemoveLeoApiTokenFromAgencies < ActiveRecord::Migration[4.2]
  def change
    remove_column :agencies, :leo_api_token, :string
  end
end
