class AddTrialExpiryDateToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :trial_expiry_date, :string
  end
end
