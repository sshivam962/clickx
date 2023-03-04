class AddReferralCodeToUserIfNotAdded < ActiveRecord::Migration[4.2]
  def change
    User.reset_column_information
    unless User.column_names.include?('referral_code')
      add_column :users, :referral_code, :string
      add_index :users, :referral_code, unique: true
    end
  end
end
