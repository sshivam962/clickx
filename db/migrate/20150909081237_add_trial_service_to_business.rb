class AddTrialServiceToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :trial_service, :boolean, :default => false
  end
end
