class AddFunnelCalendlieToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :funnel_calendlie, :string
  end
end
