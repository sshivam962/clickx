class AddReputationServiceToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :reputation_service, :boolean, default: false
  end
end
