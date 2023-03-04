class AddNullFalseToDomainContactsSentEmailsCount < ActiveRecord::Migration[5.2]
  def up
    change_column :domain_contacts, :sent_emails_count, :integer, default: 0

    DomainContact.unscoped.where(sent_emails_count: nil).update_all(sent_emails_count: 0)

    change_column :domain_contacts, :sent_emails_count, :integer, default: 0, null: false
  end

  def down
    change_column :domain_contacts, :sent_emails_count, :integer
  end
end
