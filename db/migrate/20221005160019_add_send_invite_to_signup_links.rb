class AddSendInviteToSignupLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :signup_links, :send_invite, :boolean, default: false
  end
end
