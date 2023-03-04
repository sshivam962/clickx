class ChangeColumnCompetitorsLimitInBusinesses < ActiveRecord::Migration[4.2]
  def change
    change_column_default(:businesses, :competitors_limit, 5)
  end
end
