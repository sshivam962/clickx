class ChangeNameToUniqueDirectLead < ActiveRecord::Migration[5.2]
  def change
    change_column :direct_leads, :name, :string, unique: true
  end
end
