class AddProspectingCallFieldToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :prospecting_call_link, :string

    Agency.update_all(
      prospecting_call_link: 'https://www.clickx.io/success/agency-prospecting-support'
    )
  end
end
