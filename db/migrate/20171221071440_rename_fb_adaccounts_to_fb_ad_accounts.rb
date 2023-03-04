class RenameFbAdaccountsToFbAdAccounts < ActiveRecord::Migration[5.1]
  def self.up
    rename_table :fb_adaccounts, :fb_ad_accounts
  end

  def self.down
    rename_table :fb_ad_accounts, :fb_adaccounts
  end
end
