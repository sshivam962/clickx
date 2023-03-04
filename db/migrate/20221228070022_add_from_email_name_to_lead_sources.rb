class AddFromEmailNameToLeadSources < ActiveRecord::Migration[5.2]
  def change
    add_column :lead_sources, :from_email_name, :string
  end
end
