class AddMailStatusToContractorsInvites < ActiveRecord::Migration[5.1]
  def change
    add_column :contractors_invites, :mail_status, :boolean, :default => false
    add_column :contractors_invites, :send_by_user, :integer
  end
end
