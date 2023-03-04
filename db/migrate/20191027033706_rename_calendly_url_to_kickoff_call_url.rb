class RenameCalendlyUrlToKickoffCallUrl < ActiveRecord::Migration[5.1]
  def change
    rename_column :agencies, :calendly_url, :kickoff_call_link
    add_column :agencies, :discovery_call_link, :string
    add_column :agencies, :connect_call_link, :string
  end
end
