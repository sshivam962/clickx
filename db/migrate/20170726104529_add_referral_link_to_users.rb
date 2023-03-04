class AddReferralLinkToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :referral_link, :string , default: ''
  end
end
