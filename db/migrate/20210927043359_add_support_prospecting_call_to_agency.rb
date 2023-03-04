class AddSupportProspectingCallToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :support_prospecting_call, :boolean, default: true
  end
end
