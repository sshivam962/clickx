class AddAdditionalInfoToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :goals_and_expectations, :text
    add_column :leads, :comment, :text
    add_column :leads, :next_meeting_date, :datetime
    add_column :leads, :audit_request, :string
  end
end
