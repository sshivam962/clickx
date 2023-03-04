class RenameConstractorsUsersToContractorsInvites < ActiveRecord::Migration[5.1]
  def change
    rename_table :constractors_users, :contractors_invites
  end
end
