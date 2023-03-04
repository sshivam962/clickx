class AddCompetitorsServiceToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :competitors_service, :boolean, default: true
  end
end
