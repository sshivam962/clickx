class AddCompetitorsLimitToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :competitors_limit, :integer, default: 10
  end
end
