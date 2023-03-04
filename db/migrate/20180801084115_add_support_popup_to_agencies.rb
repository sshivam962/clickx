class AddSupportPopupToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :support_popup, :boolean, default: false
  end
end
