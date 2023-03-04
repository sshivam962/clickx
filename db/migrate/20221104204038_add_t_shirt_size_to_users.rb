class AddTShirtSizeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :t_shirt_size, :string, default: nil 
    add_column :users, :birth_day, :integer, default: nil 
    add_column :users, :birth_month, :integer, default: nil 
  end
end
