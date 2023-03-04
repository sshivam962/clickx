class AddContactMailingListToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :contact_mailing_list, :string, array: true, default: []
  end
end
