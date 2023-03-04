class AddRejectedAtAndRejectedByToDirectLead < ActiveRecord::Migration[5.2]
  def change
    add_column :direct_leads, :rejected_at, :datetime
    add_column :direct_leads, :rejected_by, :integer
  end
end
