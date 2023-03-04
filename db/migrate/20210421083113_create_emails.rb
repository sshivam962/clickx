class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.string :mailer_name
      t.string :title
      t.string :to_addresses
      t.string :cc_addresses
      t.string :bcc_addresses

      t.timestamps
    end
  end
end
