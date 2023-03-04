class AddThankYouFunnelToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :thank_you_funnel, :text
  end
end
