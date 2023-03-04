class ChangeColumnTypeOfEmailAddresses < ActiveRecord::Migration[5.1]
  def change
    change_column :emails, :to_addresses, :text, array: true, default: [], using: "(string_to_array(to_addresses, ','))"
    change_column :emails, :cc_addresses, :text, array: true, default: [], using: "(string_to_array(cc_addresses, ','))"
    change_column :emails, :bcc_addresses, :text, array: true, default: [], using: "(string_to_array(bcc_addresses, ','))"
  end
end
