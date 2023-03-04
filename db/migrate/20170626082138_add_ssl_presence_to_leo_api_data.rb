class AddSslPresenceToLeoApiData < ActiveRecord::Migration[4.2]
  def change
    add_column :leo_api_data, :ssl_presence, :string
  end
end
