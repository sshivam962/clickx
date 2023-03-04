class AddSourceAndShortcodeColumnsToContractorsInvite < ActiveRecord::Migration[5.1]
  def change
    add_column :contractors_invites, :source, :string
    add_column :contractors_invites, :shortcode, :string
    add_column :contractors_invites, :workable_id, :string
  end
end
