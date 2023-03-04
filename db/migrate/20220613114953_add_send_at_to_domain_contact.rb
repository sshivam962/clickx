class AddSendAtToDomainContact < ActiveRecord::Migration[5.2]
  def change
    add_column :domain_contacts, :send_at, :datetime
  end
end
