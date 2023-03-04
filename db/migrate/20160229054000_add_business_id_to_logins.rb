class AddBusinessIdToLogins < ActiveRecord::Migration[4.2]
  def change
    add_column :logins, :business_id, :integer
  end
end
