class AddDatesToContractorsInvite < ActiveRecord::Migration[5.1]
  def change
    add_column :contractors_invites, :workable_created_at, :datetime
    add_column :contractors_invites, :workable_updated_at, :datetime
  end
end
