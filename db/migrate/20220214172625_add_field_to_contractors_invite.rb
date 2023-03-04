class AddFieldToContractorsInvite < ActiveRecord::Migration[5.1]
  def change
    add_column :contractors_invites, :email_template_name, :string
  end
end
