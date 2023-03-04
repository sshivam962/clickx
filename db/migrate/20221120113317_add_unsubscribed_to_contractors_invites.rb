class AddUnsubscribedToContractorsInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :contractors_invites, :unsubscribed, :boolean, default: false
  end
end
