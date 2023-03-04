class AddLeoApiTokenToAgencies < ActiveRecord::Migration[4.2]
  def change
    add_column :agencies, :leo_api_token, :string
  end
end
