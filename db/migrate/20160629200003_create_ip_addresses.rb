class CreateIpAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :ip_addresses do |t|
      t.string :ip

      t.timestamps null: false
    end
  end
end
