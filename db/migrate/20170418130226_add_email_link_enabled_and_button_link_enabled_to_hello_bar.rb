class AddEmailLinkEnabledAndButtonLinkEnabledToHelloBar < ActiveRecord::Migration[4.2]
  def change
    add_column :hello_bars, :email_link_enabled, :boolean, default: true
    add_column :hello_bars, :button_link_enabled, :boolean, default: false
  end
end
