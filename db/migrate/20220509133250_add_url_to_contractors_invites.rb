class AddUrlToContractorsInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :contractors_invites, :url, :string
  end
end
