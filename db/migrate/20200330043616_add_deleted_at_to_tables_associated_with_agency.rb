class AddDeletedAtToTablesAssociatedWithAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :deleted_at, :datetime
    add_column :leads, :deleted_at, :datetime
    add_column :package_subscriptions, :deleted_at, :datetime
    add_column :addresses, :deleted_at, :datetime
    add_column :support_members, :deleted_at, :datetime
    add_column :grader_reports, :deleted_at, :datetime

    add_index :users, :deleted_at
    add_index :leads, :deleted_at
    add_index :package_subscriptions, :deleted_at
    add_index :addresses, :deleted_at
    add_index :support_members, :deleted_at
    add_index :grader_reports, :deleted_at
  end
end
