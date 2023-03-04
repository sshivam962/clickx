class AddPerfectaCredsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :perfecta_username, :string
    add_column :businesses, :perfecta_password, :string
  end
end
